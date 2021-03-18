const DEFAULT_RETRY_COUNT = 5;
const INITIAL_TIMEOUT_MS = 2000;
const TIMEOUT_INCREMENT_MS = 5000;

export default class ElementFinderWithRetry {
  constructor(selector, retryCount = DEFAULT_RETRY_COUNT) {
    this.selector = selector;
    this.retryCount = retryCount;
  }

  find = async (page) => {
    let result = await page.waitForSelector(this.selector, { timeout: INITIAL_TIMEOUT_MS }).catch(() => {})
    if(!result) result = await this.retryFind(page)

    return result
  }

  retryFind = async (page, level = 0) => {
    if(level >= this.retryCount) return null

    await page.reload({ waitUntil: "networkidle0"})

    let result = await page.waitForSelector(this.selector, { timeout: (INITIAL_TIMEOUT_MS + (level * TIMEOUT_INCREMENT_MS)) }).catch(() => {})
    if(!result) result = await this.retryFind(page, level + 1)

    return result
  }
}
