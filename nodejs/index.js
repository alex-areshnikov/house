import redis from "redis";
import ApiLogger from './ApiLogger.js';
import MessagesProcessor from "./MessagesProcessor.js";

const channelName = "house_node_channel"
const loggerName = "copart-watcher"

const redis_config = {
    host: (process.env.DOCKERIZED ? "redis" : "127.0.0.1" )
}

const logger = new ApiLogger(loggerName);
const redisClient = redis.createClient(redis_config);

const messagesProcessor = new MessagesProcessor(logger)
await messagesProcessor.init();

redisClient.on("message", async (_, message) => {
    await messagesProcessor.add(message)
})

redisClient.subscribe(channelName);
await messagesProcessor.process()

process.on('uncaughtException', async (error) => {
    console.error(error)
    await logger.error(error.message, error.stack, error.constructor.name);
    process.exit(1)
});

process.on('unhandledRejection', async (error) => {
    await logger.error(error.message, error.stack, error.constructor.name);
});











