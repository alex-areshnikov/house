import { spawn } from "child_process";

const scanLotCommand = "scan-lot";

export default class CommandProcessor {
  constructor(logger) {
    this.logger = logger;
  }

  process = async (data) => {
    switch (data.command) {
      case scanLotCommand:
        const scannerProcess = spawn("yarn", ["scan_lot", data.lot_number, data.username, data.password]);

        scannerProcess.on('close', (code) => {
          this.logger.say(`scan-lot-${data.lot_number} exited with code ${code}`);
        });
        break
      default:
        await this.logger.warn(`Unrecognized command ${data.command}.`);
    }
  }
}
