export default class Auctioneer {
  constructor(lot_number) {
    this.lot_number = lot_number;
    this.url = `https://www.copart.com/lot/${lot_number}`;
  }

  watch = (page) => {

  }
}
