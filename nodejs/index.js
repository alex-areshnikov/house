import LotScanner from './LotScanner.js';
import ApiLogger from './ApiLogger.js';
import Loginner from './Loginner.js'

if (process.argv.length != 6) {
    console.log("Wrong number of arguments")
    process.exit(1);
}

const lot_number = process.argv[process.argv.length - 4]
const username = process.argv[process.argv.length - 3]
const password = process.argv[process.argv.length - 2]
const actionType = process.argv[process.argv.length - 1]

const logger = new ApiLogger(`${actionType}-lot-${lot_number}`);
const loginner = new Loginner(logger, username, password);
const scanner = new LotScanner(logger, lot_number);

await logger.say(`Starting browser routine`)

try {
    await loginner.login();

    switch (actionType) {
        case 'scan':
            if(loginner.isSuccess()) { await scanner.scan(loginner.loggedInPage()) }
            break;
        case 'auction':
            if(loginner.isSuccess()) { await auctioneer.watch(loginner.loggedInPage()) }
            break;
        default:
            console.log(`Unrecognized actionType ${actionType}.`);
    }

    await logger.say(`Completed browser routine`)
} catch(error) {
    console.error(error)
    await logger.error(error.message, error.stack, error.constructor.name);
    process.exitCode = 1
} finally {
    process.exit(process.exitCode)
}











