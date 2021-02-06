import fs from "fs";

export default class PhotosCollector {
  constructor(page) {
    this.page = page;
  }


  collect = async () => {
    const thumbElements = await this.page.$$("span.thumbImgblock")
    const photoUrls = [];

    for(const thumbElement of thumbElements) {
      await thumbElement.click({ delay: 100 })
      this.page.waitForTimeout(200)

      const hdButton = await this.page.$("span.view-hd")
      if(hdButton) {
        await hdButton.click({ delay: 100 })
        this.page.waitForTimeout(200)
      }

      photoUrls.push(await this.page.$eval(".spZoomImg", el => el.getAttribute("sp-url")))

      this.page.waitForTimeout(200)
    }

    return photoUrls
  }
}
