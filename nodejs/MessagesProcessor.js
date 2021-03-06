import CommandProcessor from "./CommandProcessor.js";
import { spawn } from "child_process";

const IDLE_DURATION_MS = 1000

export default class MessagesProcessor {
  constructor(logger) {
    this.logger = logger;
    this.messagesQueue = []

    this.commandProcessor = new CommandProcessor(logger);
  }

  init = async () => {
    await this.commandProcessor.init();
  }

  process = async () => {
    for(;;) {
      if(this.messagesQueue.length === 0) await this.idle()
      else await this.processMessage()
    }
  }

  processMessage = async () => {
    const message = this.messagesQueue.shift()

    await this.say(`Message processing ${message}`)
    await this.commandProcessor.process(JSON.parse(message))
    await this.say(`Message processed ${message}`)
  }

  add = async (message) => {
    const data = JSON.parse(message)

    if(this.commandProcessor.isCommandTypeQueue(data)) {
      this.messagesQueue.push(message)
      await this.say(`Message received and added to queue ${message}`)
      return
    }

    if(this.commandProcessor.isCommandTypeSpawn(data)) {
      this.spawnAuctionWatcher(message)

      await this.say(`Message received and spawned in a separate process ${message}`)
      return
    }

    await this.say(`Command type is unrecognized. Message ignored ${message}`)
  }

  say = async (message) => {
    await this.logger.say(`(${this.messagesQueue.length}) ${message}`)
  }

  idle = async () => {
    return new Promise(resolve => setTimeout(resolve, IDLE_DURATION_MS));
  }

  spawnAuctionWatcher = (message) => {
    const data = JSON.parse(message)

    const auctionWatcher = spawn("yarn", ["auction_watcher", message]);

    auctionWatcher.stderr.on('data', (processData) => {
      this.logger.error(`Auction watcher ${data.lot_number} stderr: ${processData}`);
    });

    auctionWatcher.on('close', (code) => {
      this.logger.say(`Auction watcher ${data.lot_number} exited with code ${code}`);
    });
  }
}
