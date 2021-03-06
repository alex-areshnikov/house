import fs from 'fs'
import puppeteer from "puppeteer-extra"
import StealthPlugin from "puppeteer-extra-plugin-stealth"
import copartLoginCredentials from "./copartLoginCredentials.js"

const DEFAULT_TIMEOUT = 20000

puppeteer.use(StealthPlugin())

let launchOptions = { headless: true }
if(process.env.DOCKERIZED) launchOptions["executablePath"] = "google-chrome-stable"

const cookies_path = "./cookies.json"
const url = "https://www.copart.com"

export default class Loginner {
  constructor(logger, username, password) {
    this.logger = logger;
    this.username = username;
    this.password = password;
    this.successfulLogin = false;
    this.cookies = null;
  }

  init = async () => {
    this.browser = await puppeteer.launch(launchOptions);
  }

  exit = async (exitCode) => {
    await this.browser.close(() => {
      process.exit(exitCode)
    })
  }

  createPage = async () => {
    const page = await this.browser.newPage()
    await page.setDefaultTimeout(DEFAULT_TIMEOUT)
    await page.setViewport({ width: 1711, height: 1101 });

    return page
  }

  login = async () => {
    await this.cookiesLogin()
    if(!this.successfulLogin) { await this.directLogin() }

    return this.successfulLogin;
  }

  isSuccess = () => {
    return this.successfulLogin
  }

  loggedInPage = async () => {
    if(!this.isSuccess()) { return }

    const page = await this.createPage();
    await page.setCookie(...this.cookies);

    return page;
  }

  close = async () => {
    await this.browser.close()
  }

  // private

  directLogin = async () => {
    const credentials = await copartLoginCredentials();

    await this.logger.say("Performing direct login...")

    const page = await this.createPage()
    await page.goto(`${url}/login`, { waitUntil: "load" })

    await page.waitForSelector('#username');
    await page.waitForSelector('#password');

    await page.evaluate( () => document.getElementById("username").value = "")
    await page.evaluate( () => document.getElementById("password").value = "")

    await page.type('#username', credentials.username, {delay: 100});
    await page.type('#password', credentials.password, {delay: 100});

    await page.click('input[name=remember-me]', {delay: 100})

    await page.click('button[data-uname=loginSigninmemberbutton]', {delay: 100})
    await page.waitForSelector('span.signout')
      .then(() => { this.successfulLogin = true })
      .catch(() => { this.successfulLogin = false })

    if(this.successfulLogin) {
      this.cookies = await page.cookies();
      await this.storeCookies();
    } else {
      await this.logger.warn("Direct login failed")
      await page.screenshot({path: `screenshots/${Date.now()}_error_direct_login.png`})
    }

    await page.close();
  }

  cookiesLogin = async () => {
    if(!await fs.existsSync(cookies_path)) { return false }
    await this.logger.say("Performing cookies login")

    const page = await this.createPage()

    const cookiesString = await fs.readFileSync(cookies_path);
    const cookies = JSON.parse(cookiesString);
    await page.setCookie(...cookies);

    await page.goto(url, { waitUntil: "load" })
    await page.waitForSelector('span.signout')
      .then(() => { this.successfulLogin = true })
      .catch(() => { this.successfulLogin = false })

    if(this.successfulLogin) { this.cookies = await page.cookies(); }
    else { await this.logger.warn("Cookies login failed") }

    await page.close()
  }

  storeCookies = async () => {
    if(await fs.existsSync(cookies_path)) { await fs.rmSync(cookies_path) }
    await fs.writeFile(cookies_path, JSON.stringify(this.cookies, null, 2), () => {  });
  }
}
