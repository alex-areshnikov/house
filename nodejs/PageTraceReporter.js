import { unlink } from 'fs/promises';
import { execSync } from "child_process";

export default class PageTraceReporter {
  constructor(logger) {
    this.logger = logger;
    this.started = false;
    this.reported = false
  }

  start = async (page) => {
    return // Tracing off
    if(this.started) { return }

    this.filePath = `tracers/${Date.now()}-${this.logger.name()}.json`
    await page.tracing.start({ path: this.filePath, screenshots: true })
    this.started = true;
  }

  report = async (page) => {
    return // Tracing off

    if(!this.started) { return }
    if(this.reported) { return }

    await page.tracing.stop()
    execSync(`gzip ${this.filePath}`)
    await this.logger.say("Trace results", `${this.filePath}.gz`)
    await unlink(`${this.filePath}.gz`)

    this.reported = true
  }
}
