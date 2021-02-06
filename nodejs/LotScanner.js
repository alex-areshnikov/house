import HouseApiClient from "./HouseApiClient.js"
import lotFields from "./lotFields.js"

export default class LotScanner {
  constructor(logger, lot_number) {
    this.logger = logger;
    this.api_client = new HouseApiClient("lot_scanner");
    this.lot_number = lot_number;
    this.url = `https://www.copart.com/lot/${lot_number}`;
  }

  scan = async (page) => {
    await this.logger.say(`Scanning ${this.url}`)

    await page.goto(this.url, { waitUntil: "load" })
    const lotExists = await page.waitForSelector('.lot-information')
      .catch(() => { this.logger.warn("Lot not found") })

    if(lotExists) {
      const data = await this.collectData(page);
      await this.api_client.send(data)
    } else {
      await page.screenshot({path: `screenshots/${Date.now()}_error_lot_${this.lot_number}_not_found.png`})
    }
  }

  // private
  collectData = async (page) => {
    let data = { lot_number: this.lot_number };

    for(const field of lotFields) {
       data[field.name] = await this.processField(page, field);
    }

    return data;
  }

  processField = async (page, field) => {
    let fieldValue = "";

    fieldValue = await page.$eval(field.selector, element => element.textContent.trim())
      .catch(() => { this.logger.warn(`${field.name} not found`) })

    // await page.screenshot({path: `screenshots/${Date.now()}_error_${field.name}.png`})

    return fieldValue;
  }
}
