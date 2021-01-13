import puppeteer from "puppeteer-extra"
import StealthPlugin from "puppeteer-extra-plugin-stealth"

import lotFields from "./lotFields.js"

puppeteer.use(StealthPlugin())

export default class LotScanner {
  constructor(lot_number) {
    this.url = `https://www.copart.com/lot/${lot_number}`;
  }

  scan = async () => {
    console.log(`Scanning ${this.url}...`)

    puppeteer.launch({ headless: true }).then(async browser => {
      const page = await browser.newPage()
      await page.setViewport({ width: 1920, height: 1080 });
      await page.goto(this.url, { waitUntil: "load" })

      await this.collectData(page);

      await browser.close()
    })
  }

  // private

  collectData = async (page) => {
    for (const field of lotFields) {
      await page
        .waitForSelector(field.selector, { timeout: 5000 })
        .then(async (element) => {
          let elementText = await page.evaluate(el => el.textContent, element);
          console.log(`${field.name}: ${elementText.trim()}`)
          // await element.screenshot({path: `${field.name}.png`})
        })
        .catch(() => console.log(`error ${field.name}`))
    }
  }
}
