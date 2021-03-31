import ApiLogger from "./ApiLogger.js";
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js";

const DEFAULT_RETRY_COUNT = 20;
const INITIAL_TIMEOUT_MS = 1;

export default class ElementFinderWithRetry {
  constructor(selector, retryCount = DEFAULT_RETRY_COUNT) {
    this.selector = selector;
    this.retryCount = retryCount;
    this.logger = new ApiLogger('element-finder-with-retry');
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(this.logger);
  }

  find = async (page) => {
    let result = await page.$(this.selector).catch(() => {})
    if(!result) result = await this.retryFind(page)

    return result
  }

  retryFind = async (page, level = 0) => {
    if(level >= this.retryCount-1) return null

    await page.reload({ waitUntil: ["load", "domcontentloaded", "networkidle0"]})
    await this.unexpectedPageStateReporter.report(page, `Retry ${level+1} ${this.selector}`)

    let result = await page.$(this.selector).catch(() => {})
    if(!result) result = await this.retryFind(page, level + 1)

    return result
  }
}
