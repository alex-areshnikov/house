import HouseApiClient from "./HouseApiClient.js"

export default class ApiLogger {
  constructor(source) {
    this.source = source
    this.api_client = new HouseApiClient("logger");
  }

  say = async (message) => {
    await this.api_client.send({
      level: "info",
      source: this.source,
      message: message
    })
  }

  warn = async (message) => {
    await this.api_client.send({
      level: "warn",
      source: this.source,
      message: message
    })
  }

  error = async (message, stack, type) => {
    await this.api_client.send({
      level: "error",
      source: this.source,
      error: type,
      message: message,
      stack: stack
    })
  }
}
