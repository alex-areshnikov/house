const DEFAULT_RETRY_COUNT = 5;
const INITIAL_TIMEOUT_MS = 2000;
const TIMEOUT_INCREMENT_MS = 5000;

export default class NavigatorWithRetry {
  constructor(url, selector, retryCount = DEFAULT_RETRY_COUNT) {
    this.url = url;
    this.selector = selector;
    this.retryCount = retryCount;
  }

  navigate = async (page) => {
    await page.goto(this.url, { waitUntil: "networkidle2"})

    let result = await page.waitForSelector(this.selector, { timeout: INITIAL_TIMEOUT_MS }).catch(() => {})
    if(!result) result = await this.retryNavigation(page)

    return result
  }

  retryNavigation = async (page, level = 0) => {
    if(level >= this.retryCount) return null

    await page.reload({ waitUntil: "networkidle2"})

    let result = await page.waitForSelector(this.selector, { timeout: (INITIAL_TIMEOUT_MS + (level * TIMEOUT_INCREMENT_MS)) }).catch(() => {})
    if(!result) result = await this.retryNavigation(page, level + 1)

    return result
  }
}
