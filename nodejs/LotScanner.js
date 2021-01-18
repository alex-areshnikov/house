import puppeteer from "puppeteer-extra"
import StealthPlugin from "puppeteer-extra-plugin-stealth"
import redis from "redis"

import lotFields from "./lotFields.js"

puppeteer.use(StealthPlugin())

const redis_config = {
  host: (process.env.DOCKERIZED ? "redis" : "127.0.0.1" )
}

export default class LotScanner {
  constructor(lot_number) {
    this.lot_number = lot_number;
    this.url = `https://www.copart.com/lot/${lot_number}`;
    this.pub_channel = "copart_lot_channel";
    this.redis_client = redis.createClient(redis_config);
  }

  scan = async () => {
    console.log(`Scanning ${this.url}`)

    puppeteer.launch({ headless: true, args: ['--no-sandbox'] }).then(async browser => {
      const page = await browser.newPage()
      await page.setViewport({ width: 1920, height: 1080 });
      await page.goto(this.url, { waitUntil: "load" })

      const data = await this.collectData(page);
      await this.redis_client.publish(this.pub_channel, JSON.stringify(data));
      await this.redis_client.quit();

      await browser.close()
    })
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
