import ApiLogger from "./ApiLogger.js";
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js";

const DEFAULT_RETRY_COUNT = 3;
const ELEMENT_WAIT_INITIAL_MS = 20000
const ELEMENT_WAIT_MS = 10000;
const API_LOGGER_NAME = 'element-finder-with-retry'

export default class ElementFinderWithRetry {
  constructor(targetSelector, retryCount = DEFAULT_RETRY_COUNT) {
    this.targetSelector = targetSelector;
    this.retryCount = retryCount;
    this.logger = new ApiLogger(API_LOGGER_NAME);
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(this.logger);
  }

  find = async (page, level = 0) => {
    let targetElement = await page.waitForSelector(this.targetSelector, { timeout: (ELEMENT_WAIT_INITIAL_MS + ELEMENT_WAIT_MS * level) }).catch(() => {})
    if(!targetElement) targetElement = await this.retryFind(page, level)

    return targetElement
  }

  retryFind = async (page, level) => {
    if(level >= this.retryCount) return null

    await page.reload({ waitUntil: ["load", "domcontentloaded"] }).catch(() => {})
    await this.unexpectedPageStateReporter.report(page, `Retry ${level+1} ${this.targetSelector}`)

    return this.find(page, level+1)
  }
}
