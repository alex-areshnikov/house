import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js"

export default class AuctionVehiclePriceProcessor {
  constructor(logger, lotNumber) {
    this.logger = logger;
    this.lotNumber = lotNumber;
    this.currentPrice = null;
    this.sold = false;
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(logger, lotNumber)
  }

  process = async (frame) => {
    const price = await this.price(frame)

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

  price = async (frame) => {
    const priceElement = await frame.waitForSelector('.auctionrunningdiv-MEGA text', { timeout: 200 }).catch(() => {})

    if(priceElement) {
      const price = await priceElement.evaluate(element => element.textContent.trim())

      this.sold = price.toLowerCase().includes("sold")
      if(!price.startsWith("$")) return null

      return price
    } else {
      await this.unexpectedPageStateReporter.report(frame, "Price element not found")
    }

    return null
  }

  processPriceChange = async (price) => {
    await this.logger.say(`[${this.lotNumber}] ${price}`)
    // TODO Send price
  }
}
