import ElementFinderWithRetry from "./ElementFinderWithRetry.js"
import ApiLogger from "./ApiLogger.js";
import UnexpectedPageStateReporter from "./UnexpectedPageStateReporter.js";

export default class NavigatorWithRetry {
  constructor(url, selector) {
    this.url = url;
    this.elementFinderWithRetry = new ElementFinderWithRetry(selector)
    this.logger = new ApiLogger('navigator-with-retry');
    this.unexpectedPageStateReporter = new UnexpectedPageStateReporter(this.logger);
  }

  navigate = async (page) => {
    await page.goto(this.url, { waitUntil: ["load", "domcontentloaded", "networkidle0", "networkidle2"]}).catch(() => { this.error = true })

    return(this.error ? null : (await this.elementFinderWithRetry.find(page)))
  }
}
