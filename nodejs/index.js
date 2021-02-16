import redis from "redis";
import ApiLogger from './ApiLogger.js';
import CommandProcessor from "./CommandProcessor.js"

const channelName = "house_node_channel"
const loggerName = "copart-watcher"

const redis_config = {
    host: (process.env.DOCKERIZED ? "redis" : "127.0.0.1" )
}

const logger = new ApiLogger(loggerName);
const redisClient = redis.createClient(redis_config);
const commandProcessor = new CommandProcessor(logger);

redisClient.setMaxListeners(20);

redisClient.on("message", async (_, message) => {
    await logger.say(`Starting browser routine ${message}`)

    const data = JSON.parse(message)
    await commandProcessor.process(data)

    await logger.say(`Completed browser routine ${message}`)
})

redisClient.subscribe(channelName);

process.on('uncaughtException', async (error) => {
    console.error(error)
    await logger.error(error.message, error.stack, error.constructor.name);
    process.exit(1)
});

process.on('unhandledRejection', async (error) => {
    await logger.error(error.message, error.stack, error.constructor.name);
});











