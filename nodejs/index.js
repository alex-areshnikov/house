import LotScanner from './LotScanner.js';
import ApiLogger from './ApiLogger.js';

const logger = new ApiLogger();

if (process.argv.length != 3) {
    console.log("Wrong number of arguments")
    process.exit(1);
}

try {
    const lot_number = process.argv[process.argv.length - 1]
    const scanner = new LotScanner(lot_number);
    await scanner.scan();
} catch(error) {
    console.log(error)
    await logger.error(error.message, error.stack, error.constructor.name);
    process.exitCode = 1
} finally {
    process.exit(process.exitCode)
}











