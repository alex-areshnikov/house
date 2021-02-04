import puppeteer from "puppeteer-extra"
import StealthPlugin from "puppeteer-extra-plugin-stealth"
import HouseApiClient from "./HouseApiClient.js"
import lotFields from "./lotFields.js"

puppeteer.use(StealthPlugin())

export default class LotScanner {
  constructor(lot_number) {
    this.api_client = new HouseApiClient("lot_scanner");
    this.lot_number = lot_number;
    this.url = `https://www.copart.com/lot/${lot_number}`;
  }

  scan = async () => {
    console.log(`Scanning ${this.url}`)

    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage()
    await page.setViewport({ width: 1920, height: 1080 });
    await page.goto(this.url, { waitUntil: "load" })

    const data = await this.collectData(page);
    await this.api_client.send(data);

    await browser.close()
  }

  // private
  collectData = async (page) => {
    let data = { lot_number: this.lot_number };

    for(const field of lotFields) {
       data[field.name] = await this.processField(page, field, false);
       console.log(`${field.name}: ${data[field.name]}`)
    }

    return data;
  }

  processField = async (page, field, reloaded) => {
    let fieldValue = "";

    await page
      .waitForSelector(field.selector, { timeout: reloaded ? 20000 : 5000 })
      .then(async (element) => {
        let elementText = await page.evaluate(el => el.textContent, element);
        fieldValue = elementText.trim();
      })
      .catch(async () => {
        console.log(`error ${field.name}`)

        if(reloaded) { await page.screenshot({path: `screenshots/${Date.now()}_error_${field.name}.png`}) }
        else {
          await page.reload({ waitUntil: "load" });
          fieldValue = await this.processField(page, field, true)
        }
      })

    return fieldValue;
  }
}
