import HouseApiClient from "./HouseApiClient.js"

export default class AuctionWatcher {
  constructor(logger, lot_number) {
    this.logger = logger;
    this.api_client = new HouseApiClient("auction_watcher");
    this.lot_number = lot_number;
    this.url = `https://www.copart.com/lot/${lot_number}`;
  }

  watch = async (page) => {
    console.log(`Opening ${this.url}`)

    await page.goto(this.url, { waitUntil: "load" })
    const lotExists = await page.waitForSelector('.lot-information')
      .catch(() => { this.logger.warn("Lot not found") })

    if(lotExists) {
      await this.processAuction(page)
    } else {
      await page.screenshot({path: `screenshots/${Date.now()}_error_lot_${this.lot_number}_not_found.png`})
    }

    // 1. find and click bid button
    // 2. check and close auction if vehicle has outdated number
    // 3. on lot change check if the lot is vehicle lot
    // 4. if so, watch and emit price
    // 5. otherwise go to 2
  }

  processAuction = async (page) => {
    const auctionButton = await page.waitForSelector('.live-auction-notification a')
      .catch(() => { this.logger.warn("Auction not found") })

    if(!auctionButton) return

    auctionButton.click({ delay: 69 })

    // TODO find iframe first

    const actionPageExists = await page.waitForSelector('.widget')
      .catch(() => { this.logger.warn("Auction page not found") })

    if(actionPageExists) {
      await this.reportAuctionLotNumber(page)
    } else {
      await page.screenshot({path: `screenshots/${Date.now()}_error_auction_page_${this.lot_number}_not_found.png`})
    }
  }

  reportAuctionLotNumber = async (page) => {
    const currentVehicleNumberElement = await page.waitForSelector('.auction-wrapper-MEGA [data-uname="lot-details-value"]')
      .catch(() => { this.logger.warn("Current vehicle number not found") })

    const targetVehicleNumberElement = await page.waitForSelector('.megaFutureLotHeaderWrapper [data-uname="lot-details-value"]')
      .catch(() => { this.logger.warn("Target vehicle number not found") })

    if(!currentVehicleNumberElement || !targetVehicleNumberElement) return

    const currentVehicleNumber = currentVehicleNumberElement.evaluate(element => element.textContent.trim())
    const targetVehicleNumber = targetVehicleNumberElement.evaluate(element => element.textContent.trim())

    this.logger.say(`Auction page found. Current vehicle ${currentVehicleNumber} / Target vehicle ${targetVehicleNumber}`)
  }
}
