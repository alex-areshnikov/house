export default class PhotosCollector {
  constructor(logger, page) {
    this.page = page;
    this.logger = logger;
  }

  collect = async () => {
    const photoUrls = [];

    await this.page.reload({ waitUntil: "load" })

    for(let index = 0; index < 10; index++) {
      photoUrls.push(await this.collectPhoto(index))
    }

    return photoUrls
  }

  collectPhoto = async (index, level = 0) => {
    const galeria = await this.page.waitForSelector('.image-galleria_wrap', { visible: true, timeout: 10000 })
      .catch(() => { this.page.screenshot({path: `screenshots/${Date.now()}_${index}_${level}_galeria_not_found.png`})})

    if(galeria) {
      const thumbButton = await this.page.waitForSelector(`.thumbnailImg[target-index="${index}"]`, { visible: true, timeout: 1000 })
        .catch(() => { this.page.screenshot({path: `screenshots/${Date.now()}_${index}_${level}_photo_thumb_not_found.png`})})

      if(thumbButton) {
        await thumbButton.click()

        const hdButton = await this.page.waitForSelector('span.view-hd', { visible: true, timeout: 200 }).catch(() => {})
        if(hdButton) { await hdButton.click() }

        const mainPhoto = await this.page.waitForSelector(".spZoomImg", { visible: true, timeout: 1000 })
          .catch(() => { this.page.screenshot({path: `screenshots/${Date.now()}_${index}_${level}_photo_url_not_found.png`})})

        if(mainPhoto) {
          return(await mainPhoto.evaluate(el => el.getAttribute("sp-url")))
        } else if(level < 3) {
          await this.logger.warn(`Retry ${level+1} photo ${index}`)
          await this.page.reload({ waitUntil: "load" })
          return(await this.collectPhoto(index, level + 1))
        } else {
          await this.logger.error(`Failed to load photo ${index}`)
        }
      }
    }
  }
}
