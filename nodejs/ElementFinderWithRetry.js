import ApiLogger from "./ApiLogger.js";
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js";

const DEFAULT_RETRY_COUNT = 5;
const BANNER_WAIT_MS = 5000;
const BANNER_SELECTOR = '.print-lot-banner'
const API_LOGGER_NAME = 'element-finder-with-retry'

export default class ElementFinderWithRetry {
  constructor(targetSelector, retryCount = DEFAULT_RETRY_COUNT) {
    this.targetSelector = targetSelector;
    this.retryCount = retryCount;
    this.logger = new ApiLogger(API_LOGGER_NAME);
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(this.logger);
  }

  find = async (page, level = 0) => {
    let targetElement = await this.findTargetElement(page)
    if(!targetElement) targetElement = await this.retryFind(page, level)

    return targetElement
  }

  retryFind = async (page, level) => {
    if(level >= this.retryCount-1) return null

    await this.unexpectedPageStateReporter.report(page, `Retry ${level+1} ${this.targetSelector}`)

    await page.reload()
    return this.find(page, level + 1)
  }

  findTargetElement = async (page) => {
    const bannerElement = await page.waitForSelector(BANNER_SELECTOR, { timeout: BANNER_WAIT_MS }).catch(() => {})
    if(bannerElement) { await this.deleteBanner(page)}

    return await page.$(this.targetSelector).catch(() => {})
  }

  deleteBanner = async (page) => {
    await page.evaluate((selector) => {
      const elements = document.querySelectorAll(selector);

      for(let i=0; i< elements.length; i++){
        elements[i].parentNode.removeChild(elements[i]);
      }
    }, BANNER_SELECTOR)
  }
}
