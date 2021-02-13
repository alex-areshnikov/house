import { spawn } from "child_process";

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

  process = async (data) => {
    switch (data.command) {
      case KNOWN_COMMANDS.scanLotCommand:
        this.spawnScanLot(data);

        break
      case KNOWN_COMMANDS.watchAuction:
        this.spawnWatchAuction(data);

        break
      case KNOWN_COMMANDS.closeAuction:
        this.closeWatchAuction(data);

        break
      default:
        await this.logger.warn(`Unrecognized command ${data.command}.`);
    }
  }

  spawnScanLot = (data) => {
    const scannerProcess = spawn("yarn", ["scan_lot", data.lot_number, data.username, data.password]);

    scannerProcess.on('close', (code) => {
      this.logger.say(`scan-lot-${data.lot_number} exited with code ${code}`);
    });
  }

  spawnWatchAuction = (data) => {
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
