import ElementFinderWithRetry from "./ElementFinderWithRetry.js"

export default class NavigatorWithRetry {
  constructor(url, selector) {
    this.url = url;
    this.elementFinderWithRetry = new ElementFinderWithRetry(selector)
  }

  navigate = async (page) => {
    await page.goto(this.url, { waitUntil: ["load", "domcontentloaded"]}).catch(() => { this.error = true })

    return(this.error ? null : (await this.elementFinderWithRetry.find(page)))
  }
}
