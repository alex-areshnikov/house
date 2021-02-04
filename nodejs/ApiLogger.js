import HouseApiClient from "./HouseApiClient.js"

export default class ApiLogger {
  constructor() {
    this.api_client = new HouseApiClient("logger");
  }

  say = async (message) => {
    await this.api_client.send({
      timestamp: Date.now(),
      message: message
    })
  }

  error = async (message, stack, type) => {
    await this.api_client.send({
      timestamp: Date.now(),
      error: type || "true",
      message: message,
      stack: stack
    })
  }
}
