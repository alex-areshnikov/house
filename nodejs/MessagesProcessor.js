import CommandProcessor from "./CommandProcessor.js";

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
      // TODO spawn
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
}
