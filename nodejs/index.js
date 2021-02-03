import LotScanner from './LotScanner.js';
import RedisLogger from './RedisLogger.js';

const logger = new RedisLogger();

if (process.argv.length != 3) {
    console.log("Wrong number of arguments")
    process.exit(1);
}

function exitCallback() {
    process.exit(process.exitCode)
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
    await logger.close(exitCallback)
}











