import { spawn } from "child_process";
import ApiLogger from "./ApiLogger.js";
import LotScanner from "./LotScanner.js";

const KNOWN_COMMANDS = {
  scanLotCommand: "scan-lot",
  watchAuction: "watch-auction",
  closeAuction: "close-auction"
}

export default class CommandProcessor {
  constructor(logger) {
    this.logger = logger;
    this.openedAuctions = {};
  }

  process = async (page, data) => {
    switch (data.command) {
      case KNOWN_COMMANDS.scanLotCommand:
        await this.performScanLot(page, data.lot_number);

        break
      case KNOWN_COMMANDS.watchAuction:
        await this.performWatchAuction(page, data);

        break
      case KNOWN_COMMANDS.closeAuction:
        this.closeWatchAuction(data);

        break
      default:
        await this.logger.warn(`Unrecognized command ${data.command}.`);
    }

    await page.close();
  }

  performScanLot = async (page, lotNumber) => {
    const scanLogger = new ApiLogger(`scan-lot-${lotNumber}`);
    let scanError = false;

    await (async () => {
      const scanner = new LotScanner(scanLogger, lotNumber);
      await scanner.scan(page)
    })().catch(async error =>  scanError = error)

    if(scanError) {
      console.error(scanError)
      await scanLogger.error(scanError.message, scanError.stack, scanError.constructor.name);
    }
  }

  spawnWatchAuction = async (data) => {
    if(this.openedAuctions[data.lot_number]) {
      this.logger.warn(`Auctioneer is already spawned for ${data.lot_number}`);
      return
    }

    const auctionProcess = spawn("yarn", ["watch_auction", data.lot_number, data.username, data.password]);

    this.openedAuctions[data.lot_number] = auctionProcess

    auctionProcess.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });

    auctionProcess.on('close', (code) => {
      this.logger.say(`watch-auction-lot-${data.lot_number} exited with code ${code}`);
    });
  }

  closeWatchAuction = (data) => {
    if(!this.openedAuctions[data.lot_number]) {
      this.logger.warn(`Can't close. Auctioneer is not found for ${data.lot_number}`);
      return
    }

    this.openedAuctions[data.lot_number].kill('SIGINT');

    delete this.openedAuctions[data.lot_number]
  }
}
