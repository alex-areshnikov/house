import LotScanner from './LotScanner.js';
import ApiLogger from './ApiLogger.js';
import Loginner from './Loginner.js'

if (process.argv.length !== 5) {
  console.error("Wrong number of arguments")
  process.exit(1);
}

const lotNumber = process.argv[process.argv.length - 3]
const username = process.argv[process.argv.length - 2]
const password = process.argv[process.argv.length - 1]

const logger = new ApiLogger(`scan-lot-${lotNumber}`);

try {
    await logger.say("Starting browser routine")

    const loginner = new Loginner(logger, username, password);
    const scanner = new LotScanner(logger, lotNumber);

    await loginner.login();

    if(loginner.isSuccess()) { await scanner.scan(loginner.loggedInPage()) }

    await logger.say("Completed browser routine")

} catch(error) {
    console.error(error)
    await logger.error(error.message, error.stack, error.constructor.name);
    process.exitCode = 1
} finally {
    process.exit(process.exitCode)
}

process.on('unhandledRejection', async (error) => {
  await logger.error(error.message, error.stack, error.constructor.name);
});
