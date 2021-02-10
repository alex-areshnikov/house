export default class PhotosCollector {
  constructor(page) {
    this.page = page;
  }

  collect = async () => {
    const photoUrls = [];
    const thumbElements = await this.page.$$("#small-img-roll span.thumbImgblock")

    for(const thumbElement of thumbElements) {
      await thumbElement.click({ delay: 20 })

      const hdButton = await this.page.waitForSelector('span.view-hd', { visible: true, timeout: 200 }).catch(() => {})
      if(hdButton) {
        await hdButton.click({ delay: 20 })
      }

      const zoomElement = await this.page.waitForSelector(".spZoomImg")
        .catch(() => { this.page.screenshot({path: `screenshots/${Date.now()}_sp_zoom_img_not_found.png`})})

      if(zoomElement) {
        photoUrls.push(await zoomElement.evaluate(el => el.getAttribute("sp-url")))
      }
    }

    return photoUrls
  }
}
