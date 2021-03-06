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

const QUEUE_COMMAND_TYPE = 1
const SPAWN_COMMAND_TYPE = 2

const COMMANDS_TYPES = {}
COMMANDS_TYPES[KNOWN_COMMANDS.scanLot] = QUEUE_COMMAND_TYPE
COMMANDS_TYPES[KNOWN_COMMANDS.collectLotPhotos] = QUEUE_COMMAND_TYPE
COMMANDS_TYPES[KNOWN_COMMANDS.watchAuction] = SPAWN_COMMAND_TYPE
COMMANDS_TYPES[KNOWN_COMMANDS.closeAuction] = SPAWN_COMMAND_TYPE

export default class CommandProcessor {
  constructor(logger) {
    this.logger = logger;
    this.openedAuctions = {};
    this.loginner = new Loginner(logger);
  }

  init = async () => {
    await this.loginner.init();
  }

  exit = async (exitCode) => {
   await this.loginner.exit(exitCode);
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

  isCommandTypeQueue = (data) => {
    return COMMANDS_TYPES[data.command] === QUEUE_COMMAND_TYPE
  }

  isCommandTypeSpawn = (data) => {
    return COMMANDS_TYPES[data.command] === SPAWN_COMMAND_TYPE
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

    let auctionError = false

    await (async () => {
      const auctionWatcher = new AuctionWatcher(this.logger, lotNumber);
      await auctionWatcher.watch(page)
    })().catch(error => auctionError = error)

    if(auctionError) {
      console.error(auctionError)
      await this.logger.error(auctionError.message, auctionError.stack, auctionError.constructor.name);
    }

    await page.close();
  }

  performCloseAuction = async (lotNumber) => {
    // await auctionWatcher.requestClose()
  }
}
