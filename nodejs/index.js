import LotScanner from './LotScanner.js';

if(process.argv.length != 3) {
    console.log("Wrong number of arguments")
    process.exit(1);
}

const lot_number = process.argv[process.argv.length - 1]
const scanner = new LotScanner(lot_number);
await scanner.scan();











