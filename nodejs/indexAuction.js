import ApiLogger from './ApiLogger.js';
import CommandProcessor from "./CommandProcessor.js";



if (process.argv.length !== 3) {
  await logger.error("Wrong number of arguments")
  process.exit(1);
}

const message = process.argv[process.argv.length - 1]
const data = JSON.parse(message)

const logger = new ApiLogger(`auction-watcher-${data.lot_number}`);

const commandProcessor = new CommandProcessor(logger);
await commandProcessor.init();
await commandProcessor.process(data)
await commandProcessor.exit(0);

process.on('uncaughtException', async (error) => {
  console.error(error)
  await logger.error(error.message, error.stack, error.constructor.name);
  await commandProcessor.exit(1);
});

process.on('unhandledRejection', async (error) => {
  await logger.error(error.message, error.stack, error.constructor.name);
});











