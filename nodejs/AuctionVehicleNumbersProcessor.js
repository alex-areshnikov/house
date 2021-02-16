export default class AuctionVehicleNumbersProcessor {
  constructor(logger, lotNumber) {
    this.logger = logger;
    this.lotNumber = lotNumber;
    this.currentNumber = null;
    this.targetNumber = null;
    this.currentNumberChanged = false;
  }

  processTarget = (targetNumber) => {
    this.targetNumber = Number(targetNumber)
  }

  processCurrent = (newCurrentNumber) => {
    newCurrentNumber = Number(newCurrentNumber)

    if(newCurrentNumber !== this.currentNumber) {
      this.currentNumberChanged = true
      this.currentNumber = newCurrentNumber
    }
  }

  currentNotFound = () => {
    if(this.currentNumber && this.targetNumber) {
      this.currentNumber = this.targetNumber + 1 // force auction end
    }
  }

  isCurrentBeforeOrMatchTarget = () => {
    if(!this.currentNumber || !this.targetNumber) return true

    return this.currentNumber <= this.targetNumber
  }

  isMatch = () => {
    if(!this.currentNumber || !this.targetNumber) return false

    return this.currentNumber === this.targetNumber
  }

  isCurrentPassedTarget = () => {
    if(!this.currentNumber || !this.targetNumber) return false

    return this.currentNumber > this.targetNumber
  }

  report = async () => {
    if(!this.currentNumber || !this.targetNumber) return
    if(!this.currentNumberChanged) return

    this.currentNumberChanged = false;

    await this.logger.say(`Current vehicle ${this.currentNumber} / Target vehicle ${this.targetNumber }`)
    // TODO send current/target number
  }
}
