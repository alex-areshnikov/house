export default class NavigatorWithRetry {
  constructor(url, selector, retryCount = 3) {
    this.url = url;
    this.selector = selector;
    this.retryCount = retryCount;
  }

  navigate = async (page) => {
    await page.goto(this.url, { waitUntil: "networkidle2"})

    let result = await page.waitForSelector(this.selector, { timeout: 2000 }).catch(() => {})
    if(!result) result = await this.retryNavigation(page)

    return result
  }

  retryNavigation = async (page, level = 0) => {
    if(level >= this.retryCount) return null

    await page.reload({ waitUntil: "networkidle2"})

    let result = await page.waitForSelector(this.selector, { timeout: (2000 + (level * 2000)) }).catch(() => {})
    if(!result) result = await this.retryNavigation(page, level + 1)

    return result
  }
}
