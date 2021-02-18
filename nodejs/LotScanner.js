import HouseApiClient from "./HouseApiClient.js"
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js"
import lotFields from "./lotFields.js"
import NavigatorWithRetry from "./NavigatorWithRetry.js"

export default class LotScanner {
  constructor(logger, lotNumber) {
    this.logger = logger;
    this.apiClient = new HouseApiClient("lot_scanner");
    this.lotNumber = lotNumber;
    this.url = `https://www.copart.com/lot/${lotNumber}`;

    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(logger, lotNumber)
  }

  scan = async (page) => {
    await this.logger.say(`Scanning ${this.url}`)

    const navigator = new NavigatorWithRetry(this.url, "#show-img")
    const bigImageElement = await navigator.navigate(page)

    if(bigImageElement) {
      const data = await this.collectData(page);
      await this.apiClient.send(data)
    } else {
      await this.unexpectedPageStateReporter.report(page, "Lot not found")
    }
  }

  // private
  collectData = async (page) => {
    let data = { lot_number: this.lotNumber };

    for(const field of lotFields) {
       data[field.name] = await this.processField(page, field);
    }

    return data;
  }

  processField = async (page, field) => {
    const fieldSelector = await page.waitForSelector(field.selector).catch(() => {})

    if(fieldSelector) {
      return await fieldSelector.evaluate(element => element.textContent.trim())
    } else {
      await this.unexpectedPageStateReporter.report(page, `Field ${field.name} not found`)
      return ""
    }
  }
}
