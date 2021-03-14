import HouseApiClient from "./HouseApiClient.js"
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js"
import NavigatorWithRetry from "./NavigatorWithRetry.js"

const LEVEL_LIMIT = 3

export default class PhotosCollector {
  constructor(logger, lotNumber) {
    this.logger = logger;
    this.apiClient = new HouseApiClient("photos_collector");
    this.lotNumber = lotNumber
    this.url = `https://www.copart.com/lot/${lotNumber}`;

    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(logger, lotNumber)
  }

  collect = async (page) => {
    const photoUrls = [];
    await this.logger.say("Collecting photos")

    const navigator = new NavigatorWithRetry(this.url, "#show-img")
    const bigImageElement = await navigator.navigate(page)

    if(bigImageElement) {
      for(let index = 0; index < 10; index++) {
        photoUrls.push(await this.collectPhoto(page, index))
      }

      const data = { lot_number: this.lotNumber, photo_urls: JSON.stringify(photoUrls) };
      await this.apiClient.send(data)
    } else {
      await this.unexpectedPageStateReporter.report(page, "Lot not found")
    }
  }

  collectPhoto = async (page, index, level = 0) => {
    const galeria = await page.waitForSelector('.image-galleria_wrap', { visible: true, timeout: 10000 }).catch(() => {})

    if(galeria) {
      const thumbButton = await page.waitForSelector(`.thumbnailImg[target-index="${index}"]`, { visible: true, timeout: 1000 }).catch(() => {})

      if(thumbButton) {
        await thumbButton.click()

        const hdButton = await page.waitForSelector('span.view-hd', { visible: true, timeout: 200 }).catch(() => {})
        if(hdButton) { await hdButton.click() }

        const mainPhoto = await page.waitForSelector(".spZoomImg", { visible: true, timeout: 1000 }).catch(() => {})

        if(mainPhoto) {
          return(await mainPhoto.evaluate(el => el.getAttribute("sp-url")))
        } else if(level < LEVEL_LIMIT) {
          await this.logger.warn(`Retry ${level+1} photo ${index}`)
          await page.reload({ waitUntil: "load" })
          return(await this.collectPhoto(page, index, level + 1))
        } else {
          await this.unexpectedPageStateReporter.report(page, `${index} failed to load photo`)
        }
      } else {
        await this.unexpectedPageStateReporter.report(page, `${index} ${level} thumb icon not found`)
      }
    } else {
      await this.unexpectedPageStateReporter.report(page, `${index} ${level} galeria not found`)
    }
  }
}
