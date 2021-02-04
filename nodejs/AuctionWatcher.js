import puppeteer from "puppeteer-extra"
import StealthPlugin from "puppeteer-extra-plugin-stealth"
import HouseRedisClient from "./HouseRedisClient.js"
import lotFields from "./lotFields.js"

puppeteer.use(StealthPlugin())

export default class LotScanner {
  constructor(lot_number) {
    this.redis_client = new HouseRedisClient("auction_watcher");
    this.lot_number = lot_number;
    this.url = `https://www.copart.com/lot/${lot_number}`;
  }

  watch = async () => {
    console.log(`Opening ${this.url}`)

    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage()
    await page.setViewport({ width: 1920, height: 1080 });
    await page.goto(this.url, { waitUntil: "load" })

    // 1. find and click bid button
    // 2. check and close auction if vehicle has outdated number
    // 3. on lot change check if the lot is vehicle lot
    // 4. if so, watch and emit price
    // 5. otherwise go to 2

    await browser.close()
  }
}
