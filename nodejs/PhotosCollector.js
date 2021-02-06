export default class PhotosCollector {
  constructor(page) {
    this.page = page;
  }

  collect = async () => {
    const photoUrls = [];
    const thumbElements = await this.page.$$("span.thumbImgblock")

    for(const thumbElement of thumbElements) {
      await thumbElement.click({ delay: 100 })
      this.page.waitForTimeout(200)

      const hdButton = await this.page.$("span.view-hd")
      if(hdButton) {
        await hdButton.click({ delay: 100 })
        this.page.waitForTimeout(200)
      }

      const zoomElement = await this.page.waitForSelector(".spZoomImg")
        .catch(() => { this.page.screenshot({path: `screenshots/${Date.now()}_sp_zoom_img_not_found.png`})})

      if(zoomElement) {
        photoUrls.push(await zoomElement.evaluate(el => el.getAttribute("sp-url")))
      }

      this.page.waitForTimeout(200)
    }

    return photoUrls
  }
}
