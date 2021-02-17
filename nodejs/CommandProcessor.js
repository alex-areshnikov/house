import ApiLogger from "./ApiLogger.js";
import LotScanner from "./LotScanner.js";
import AuctionWatcher from "./AuctionWatcher.js";
import Loginner from "./Loginner.js";
import PhotosCollector from "./PhotosCollector.js"

const KNOWN_COMMANDS = {
  scanLot: "scan-lot",
  collectLotPhotos: "collect-lot-photos",
  watchAuction: "watch-auction",
  closeAuction: "close-auction"
}

export default class CommandProcessor {
  constructor(logger) {
    this.logger = logger;
    this.openedAuctions = {};
    this.loginner = new Loginner(logger);
  }

  process = async (data) => {
    switch (data.command) {
      case KNOWN_COMMANDS.scanLot:
        await this.performScanLot(data.lot_number);

        break
      case KNOWN_COMMANDS.collectLotPhotos:
        await this.performCollectLotPhotos(data.lot_number);

        break
      case KNOWN_COMMANDS.watchAuction:
        await this.performWatchAuction(data.lot_number);

        break
      case KNOWN_COMMANDS.closeAuction:
        await this.performCloseAuction(data.lot_number);

        break
      default:
        await this.logger.warn(`Unrecognized command ${data.command}.`);
    }
  }

  loggedInPage = async () => {
    if(await this.loginner.login()) {
      return await this.loginner.loggedInPage()
    } else {
      await this.logger.error("Log in was not successful")
    }
  }

  performScanLot = async (lotNumber) => {
    const page = await this.loggedInPage()
    if(!page) return

    const scanLogger = new ApiLogger(`scan-lot-${lotNumber}`);
    let scanError = false;

    await (async () => {
      const scanner = new LotScanner(scanLogger, lotNumber);
      await scanner.scan(page)
    })().catch(error =>  scanError = error)

    if(scanError) {
      console.error(scanError)
      await scanLogger.error(scanError.message, scanError.stack, scanError.constructor.name);
    }

    await page.close();
  }

  performCollectLotPhotos = async (lotNumber) => {
    const page = await this.loggedInPage()
    if(!page) return

    const photosCollectorLogger = new ApiLogger(`collect-photos-lot-${lotNumber}`);
    let collectError = false;

    await (async () => {
      const photosCollector = new PhotosCollector(photosCollectorLogger, lotNumber);
      await photosCollector.collect(page)
    })().catch(error =>  collectError = error)

    if(collectError) {
      console.error(collectError)
      await photosCollectorLogger.error(collectError.message, collectError.stack, collectError.constructor.name);
    }

    await page.close();
  }

  performWatchAuction = async (lotNumber) => {
    const page = await this.loggedInPage()
    if(!page) return

    if(this.openedAuctions[lotNumber]) {
      this.logger.warn(`Auctioneer is already spawned for ${lotNumber}`);
      return
    }

    const auctionLogger = new ApiLogger(`watch-auction-lot-${lotNumber}`);
    let auctionError = false

    await (async () => {
      const auctionWatcher = new AuctionWatcher(auctionLogger, lotNumber);
      this.openedAuctions[lotNumber] = auctionWatcher

      await auctionWatcher.watch(page)
    })().catch(error => auctionError = error)

    if(auctionError) {
      console.error(auctionError)
      await auctionLogger.error(auctionError.message, auctionError.stack, auctionError.constructor.name);
    }

    delete this.openedAuctions[lotNumber]

    await page.close();
  }

  performCloseAuction = async (lotNumber) => {
    const auctionWatcher = this.openedAuctions[lotNumber]

    if(!auctionWatcher) {
      await this.logger.warn(`Can't close. Auctioneer is not found for ${lotNumber}`);
      return
    }

    await auctionWatcher.requestClose()
  }
}
