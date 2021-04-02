import HouseApiClient from "./HouseApiClient.js"
import AuctionVehicleNumbersProcessor from "./AuctionVehicleNumbersProcessor.js"
import AuctionVehiclePriceProcessor from "./AuctionVehiclePriceProcessor.js"
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js"
import NavigatorWithRetry from "./NavigatorWithRetry.js"
import ElementFinderWithRetry from "./ElementFinderWithRetry.js";
import PageTraceReporter from "./PageTraceReporter.js";

const AUCTION_FRAME_NAME = "iAuction5"
const HALF_SECOND = 500

export default class AuctionWatcher {
  constructor(logger, lotNumber) {
    this.logger = logger;
    this.apiClient = new HouseApiClient("auction_watcher");
    this.url = `https://www.copart.com/lot/${lotNumber}`;

    this.auctionVehicleNumbersProcessor = new AuctionVehicleNumbersProcessor(logger, lotNumber)
    this.auctionVehiclePriceProcessor = new AuctionVehiclePriceProcessor(logger, lotNumber)
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(logger, lotNumber)

    this.pageTraceReporter = new PageTraceReporter(logger)

    this.closeRequested = false
  }

  watch = async (page) => {
    await this.logger.say(`Opening ${this.url}`)

    await this.pageTraceReporter.start(page)

    const navigator = new NavigatorWithRetry(this.url, '.live-auction-notification a')
    const auctionButton = await navigator.navigate(page)

    if(auctionButton) {
      await auctionButton.click()
      await page.waitForNavigation({ waitUntil: ["load", "domcontentloaded"]}).catch(() => {})
      await this.processAuction(page)
    } else {
      await this.unexpectedPageStateReporter.report(page, "Auction not found")
    }

    await this.pageTraceReporter.report(page)
  }

  processAuction = async (page) => {
    const frame = await this.auctionFrame(page)

    if(frame) {
      await this.adjustAuctionWindow(page, frame)
      await this.processFrame(page, frame)
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
    const elementFinderWithRetry = new ElementFinderWithRetry(`#${AUCTION_FRAME_NAME}`)
    const frameElement = await elementFinderWithRetry.find(page)

    if(frameElement) {
      const frames = await page.frames()

      for(const frame of frames) {
        if(await frame.name() === AUCTION_FRAME_NAME) return frame;
      }
    }

    await this.unexpectedPageStateReporter.report(page, "Frame not found")

    return false
  }

  processFrame = async (page, frame) => {
    const elementFinderWithRetry = new ElementFinderWithRetry('.widget')
    const widgetElement = elementFinderWithRetry.find(frame)

    await this.pageTraceReporter.report(page)

    if(widgetElement) {
      if(await this.processTargetNumber(page, frame)) {
        do {
          await this.processCurrentNumber(page, frame)
          if(this.auctionVehicleNumbersProcessor.isMatch()) { await this.auctionVehiclePriceProcessor.process(page, frame) }
          await page.waitForTimeout(HALF_SECOND)
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
