import HouseApiClient from "./HouseApiClient.js"
import AuctionVehicleNumbersProcessor from "./AuctionVehicleNumbersProcessor.js"
import AuctionVehiclePriceProcessor from "./AuctionVehiclePriceProcessor.js"
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js"

const AUCTION_FRAME_NAME = "iAuction5"
const ONE_SECOND = 1000

export default class AuctionWatcher {
  constructor(logger, lotNumber) {
    this.logger = logger;
    this.apiClient = new HouseApiClient("auction_watcher");
    this.url = `https://www.copart.com/lot/${lotNumber}`;

    this.auctionVehicleNumbersProcessor = new AuctionVehicleNumbersProcessor(logger, lotNumber)
    this.auctionVehiclePriceProcessor = new AuctionVehiclePriceProcessor(logger, lotNumber)
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(logger, lotNumber)

    this.closeRequested = false
  }

  watch = async (page) => {
    await this.logger.say(`Opening ${this.url}`)

    await page.goto(this.url, { waitUntil: "load" })
    const lotExists = await page.waitForSelector('.lot-information').catch(() => {})

    if(lotExists) {
      await this.processAuction(page)
    } else {
      await this.unexpectedPageStateReporter.report(page, "Lot not found")
    }
  }

  processAuction = async (page) => {
    const auctionButton = await page.waitForSelector('.live-auction-notification a').catch(() => {})

    if(!auctionButton) {
      await this.unexpectedPageStateReporter.report(page, "Auction not found")
      return
    }

    await auctionButton.click()
    await page.waitForNavigation({ waitUntil: "networkidle2" }).catch(() => {})

    const frame = await this.auctionFrame(page)

    if(frame){
      await this.adjustAuctionWindow(page, frame)
      await this.processFrame(page, frame)
    } else {
      await this.unexpectedPageStateReporter.report(page, "Frame not found")
    }
  }

  adjustAuctionWindow = async (page, frame) => {
    const notActiveMegaViewButton = await frame.waitForSelector('span.nav-option-on[data-uname="showMegaView"]').catch(() => {})

    if(notActiveMegaViewButton) {
      await notActiveMegaViewButton.click()
      await page.waitForTimeout(1000)
    }
  }

  auctionFrame = async (page) => {
    const frames = await page.frames()

    for(const frame of frames) {
      if(await frame.name() === AUCTION_FRAME_NAME) return frame;
    }

    return null
  }

  processFrame = async (page, frame) => {
    const actionPageExists = await frame.waitForSelector('.widget').catch(() => {})

    if(actionPageExists) {
      if(await this.processTargetNumber(page, frame)) {
        do {
          await this.processCurrentNumber(page, frame)
          if(this.auctionVehicleNumbersProcessor.isMatch()) { await this.auctionVehiclePriceProcessor.process(frame) }
          await page.waitForTimeout(ONE_SECOND)
        } while (this.auctionVehicleNumbersProcessor.isCurrentBeforeOrMatchTarget()
                  && !this.closeRequested && !this.auctionVehiclePriceProcessor.isSold());

        if(this.auctionVehiclePriceProcessor.isSold()) {
          await this.logger.say(`The vehicle is sold for ${this.auctionVehiclePriceProcessor.lastPrice()}`)
        }

        if(this.auctionVehicleNumbersProcessor.isCurrentPassedTarget()) {
          await this.logger.warn("The target has already passed")
        }
      }
    } else {
      await this.unexpectedPageStateReporter.report(page, "Auction page not found")
    }
  }

  processCurrentNumber = async (page, frame) => {
    const currentNumberElement = await frame.waitForSelector('.auction-wrapper-MEGA span[data-uname="lot-details-value"]').catch(() => {})

    if(currentNumberElement) {
      const currentNumber = await currentNumberElement.evaluate(element => element.textContent.trim())
      await this.auctionVehicleNumbersProcessor.processCurrent(currentNumber)
      await this.auctionVehicleNumbersProcessor.report()
    } else {
      await this.auctionVehicleNumbersProcessor.currentNotFound()
      await this.unexpectedPageStateReporter.report(page, "Current vehicle number not found")
    }
  }

  processTargetNumber = async (page, frame) => {
    const lotLink = await frame.waitForSelector(`a[href="${this.url}"]`).catch(() => {})

    if(lotLink) {
      const trElement = (await lotLink.$x('ancestor::tr'))[0];
      const targetNumber = await trElement.$eval("span:last-child", element => element.textContent.trim())

      await this.auctionVehicleNumbersProcessor.processTarget(targetNumber)
      return true
    } else {
      await this.unexpectedPageStateReporter.report(page, "Target vehicle number not found")
      return false
    }
  }

  requestClose = async () => {
    this.closeRequested = true

    await this.logger.say("Auction close requested. Exiting now.")
  }
}
