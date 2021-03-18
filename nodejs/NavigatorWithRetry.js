import ElementFinderWithRetry from "./ElementFinderWithRetry.js"

export default class NavigatorWithRetry {
  constructor(url, selector) {
    this.url = url;
    this.elementFinderWithRetry = new ElementFinderWithRetry(selector)
  }

  navigate = async (page) => {
    await page.goto(this.url, { waitUntil: "networkidle2"})

    return await this.elementFinderWithRetry.find(page)
  }
}
