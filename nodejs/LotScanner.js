import HouseApiClient from "./HouseApiClient.js"
import lotFields from "./lotFields.js"

export default class LotScanner {
  constructor(lot_number) {
    this.api_client = new HouseApiClient("lot_scanner");
    this.lot_number = lot_number;
    this.url = `https://www.copart.com/lot/${lot_number}`;
    this.pageNotFound = false;
  }

  scan = async (page) => {
    console.log(`Scanning ${this.url}`)

    await page.goto(this.url, { waitUntil: "load" })
    const data = await this.collectData(page);

    if(!this.pageNotFound) { await this.api_client.send(data) }
  }

  // private
  collectData = async (page) => {
    let data = { lot_number: this.lot_number };

    for(const field of lotFields) {
       data[field.name] = await this.processField(page, field, false);
       if(this.pageNotFound) { return }
       console.log(`${field.name}: ${data[field.name]}`)
    }

    return data;
  }

  processField = async (page, field, reloaded) => {
    let fieldValue = "";

    await page
      .waitForSelector(field.selector)
      .then(async (element) => {
        let elementText = await page.evaluate(el => el.textContent, element);
        fieldValue = elementText.trim();
      })
      .catch(async () => {
        console.log(`error ${field.name}`)

        await this.checkPageNotFound(page)

        if(this.pageNotFound) { console.log("Page Not Found") }
        else {
          if(reloaded) { await page.screenshot({path: `screenshots/${Date.now()}_error_${field.name}.png`}) }
          else {
            await page.reload({ waitUntil: "load" });
            fieldValue = await this.processField(page, field, true)
          }
        }
      })

    return fieldValue;
  }

  checkPageNotFound = async (page) => {
    await page.waitForSelector('span[content="404 - Page Not Found"]')
      .then(() => { this.pageNotFound = true })
      .catch(() => { this.pageNotFound = false })
  }
}
