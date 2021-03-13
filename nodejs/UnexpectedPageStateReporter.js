import { unlink } from 'fs/promises';

export default class UnexpectedPageStateReporter {
  constructor(logger, lotNumber = null) {
    this.logger = logger;
    this.lotNumber = lotNumber;
  }

  report = async (screenshotSource, message) => {
    const underscoredMessage = message.toLowerCase().replace(/ /g,"_");
    const screenshotFileName = [Date.now(), this.lotNumber, underscoredMessage].filter(el => el != null).join("_")

    const screenshotPath = `screenshots/${screenshotFileName}.png`
    await screenshotSource.screenshot({path: screenshotPath})
    await this.logger.warn(message, screenshotPath)
    await unlink(screenshotPath)
  }
}
