import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js"

export default class AuctionVehiclePriceProcessor {
  constructor(logger, lotNumber) {
    this.logger = logger;
    this.lotNumber = lotNumber;
    this.currentPrice = null;
    this.sold = false;
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(logger, lotNumber)
  }

  process = async (page, frame) => {
    const price = await this.price(page, frame)

    if(price && price !== this.currentPrice) {
      await this.processPriceChange(price)
      this.currentPrice = price
    }
  }

  isSold = () => {
    return this.sold
  }

  lastPrice = () => {
    return this.currentPrice
  }

  price = async (page, frame) => {
    const priceElement = await frame.waitForSelector('.auctionrunningdiv-MEGA text', { timeout: 200 }).catch(() => {})

    if(priceElement) {
      let priceText = await priceElement.evaluate(element => element.textContent.trim())

      this.sold = priceText.toLowerCase().includes("sold")
      if(!priceText.startsWith("$")) return null

      const locationElement = await frame.waitForSelector('.auctionrunningdiv-MEGA text:nth-of-type(2)', { timeout: 200 }).catch(() => {})

      if(locationElement) {
        const locationText = await locationElement.evaluate(element => element.textContent.trim())
        priceText = `${priceText} ${locationText}`
      }

      return priceText
    } else {
      await this.unexpectedPageStateReporter.report(page, "Price element not found")
    }

    return null
  }

  processPriceChange = async (price) => {
    await this.logger.say(`[${this.lotNumber}] ${price}`)
    // TODO Send price
  }
}
