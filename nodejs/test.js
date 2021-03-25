import puppeteer from "puppeteer-extra"
import StealthPlugin from "puppeteer-extra-plugin-stealth"

puppeteer.use(StealthPlugin())

const browser = await puppeteer.launch({ headless: true });

const page = await browser.newPage()

await page.setDefaultTimeout(10000)
await page.setViewport({ width: 1711, height: 1101 });

await page.goto("https://www.copart.com/", { waitUntil: ["load", "domcontentloaded", "networkidle0", "networkidle2"]})

await page.waitForSelector('#kiosksignout')

const div = await page.waitForSelector('p:nth-of-type(2)');

await div.screenshot({ path: 'test.png' })

// console.log(`divs: ${JSON.stringify(divs.at(2))}`)


await browser.close()
