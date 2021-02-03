import redis from "redis"

const redis_config = {
  host: (process.env.DOCKERIZED ? "redis" : "127.0.0.1" )
}

export default class HouseRedisClient {
  constructor(communicator) {
    this.pub_channel = "copart_lot_channel";
    this.redis_client = redis.createClient(redis_config);
    this.communicator = communicator || "unknown";
  }

  publish = async (data) => {
    const decorated_data = {
      communicator: this.communicator,
      data: data
    }

    await this.redis_client.publish(this.pub_channel, JSON.stringify(decorated_data));
  }

  close = async (exitCallback) => {
    await this.redis_client.quit(exitCallback);
  }
}
