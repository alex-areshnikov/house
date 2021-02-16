export default class UnexpectedPageStateReporter {
  constructor(logger, lotNumber = null) {
    this.logger = logger;
    this.lotNumber = lotNumber;
  }

  report = async (screenshotSource, message) => {
    const underscoredMessage = message.toLowerCase().replace(/ /g,"_");
    const screenshotFileName = [Date.now(), this.lotNumber, underscoredMessage].filter(el => el != null).join("_")

    await this.logger.warn(message)
    await screenshotSource.screenshot({path: `screenshots/${screenshotFileName}.png`})
  }
}
