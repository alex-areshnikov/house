import HouseRedisClient from "./HouseRedisClient.js"

export default class RedisLogger {
  constructor() {
    this.redis_client = new HouseRedisClient("logger");
  }

  say = async (message) => {
    await this.redis_client.publish({
      timestamp: Date.now(),
      message: message
    })
  }

  error = async (message, stack, type) => {
    await this.redis_client.publish({
      timestamp: Date.now(),
      error: type || "true",
      message: message,
      stack: stack
    })
  }

  close = async (exitCallback) => {
    await this.redis_client.close(exitCallback);
  }
}
