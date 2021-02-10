import ApiLogger from './ApiLogger.js';
import redis from "redis";
import CommandProcessor from "./CommandProcessor.js"

const channelName = "house_node_channel"
const loggerName = "copart-watcher"

const redis_config = {
    host: (process.env.DOCKERIZED ? "redis" : "127.0.0.1" )
}

const logger = new ApiLogger(loggerName);
const subscriber = redis.createClient(redis_config);
const commandProcessor = new CommandProcessor(logger)

subscriber.on("message", async (_, message) => {
    try {
        const data = JSON.parse(message)

        await logger.say(`Executing command: ${data.command}`)
        await commandProcessor.process(data)

    } catch(error) {
        console.error(error)
        await logger.error(error.message, error.stack, error.constructor.name);
    }
})

subscriber.subscribe(channelName);











