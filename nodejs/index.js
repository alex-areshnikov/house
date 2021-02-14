import redis from "redis";
import ApiLogger from './ApiLogger.js';
import CommandProcessor from "./CommandProcessor.js"
import Loginner from "./Loginner.js";

const channelName = "house_node_channel"
const loggerName = "copart-watcher"

const redis_config = {
    host: (process.env.DOCKERIZED ? "redis" : "127.0.0.1" )
}

const logger = new ApiLogger(loggerName);
const redisClient = redis.createClient(redis_config);
const commandProcessor = new CommandProcessor(logger);
const loginner = new Loginner(logger);

redisClient.on("message", async (_, message) => {
    await logger.say("Starting browser routine")

    if(await loginner.login()) {
        const data = JSON.parse(message)

        await logger.say(`Executing command: ${data.command}`)

        const page = await loginner.loggedInPage()
        await commandProcessor.process(page, data)
    } else {
        await logger.error("Log in was not successful")
    }

    await logger.say("Completed browser routine")
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











