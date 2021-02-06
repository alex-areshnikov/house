import fs from 'fs'
import puppeteer from "puppeteer-extra"
import StealthPlugin from "puppeteer-extra-plugin-stealth"

puppeteer.use(StealthPlugin())

const cookies_path = "./cookies.json"
const url = "https://www.copart.com"

export default class Loginner {
  constructor(logger, username, password) {
    this.logger = logger;
    this.username = username;
    this.password = password;
    this.successfulLogin = false;
  }

  login = async () => {
    this.browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    this.page = await this.browser.newPage()
    await this.page.setDefaultTimeout(10000)
    await this.page.setViewport({ width: 1711, height: 1101 });

    await this.cookiesLogin()

    if(!this.successfulLogin) { await this.directLogin() }

    return this.successfulLogin;
  }

  isSuccess = () => {
    return this.successfulLogin
  }

  loggedInPage = () => {
    if(!this.isSuccess()) { return }

    return this.page;
  }

  close = async () => {
    await this.browser.close()
  }

  // private

  directLogin = async () => {
    await this.logger.say("Performing direct login...")
    await this.page.goto(`${url}/login`, { waitUntil: "load" })

    await this.page.waitForSelector('#username');
    await this.page.waitForSelector('#password');

    await this.page.evaluate( () => document.getElementById("username").value = "")
    await this.page.evaluate( () => document.getElementById("password").value = "")

    await this.page.type('#username', this.username, {delay: 100});
    await this.page.type('#password', this.password, {delay: 100});

    await this.page.click('input[name=remember-me]', {delay: 100})

    await this.page.click('button[data-uname=loginSigninmemberbutton]', {delay: 100})
    await this.page.waitForSelector('span.signout')
      .then(() => { this.successfulLogin = true })
      .catch(() => { this.successfulLogin = false })

    if(this.successfulLogin) {
      await this.storeCookies();
    } else {
      await this.logger.warn("Direct login failed")
      await this.page.screenshot({path: `screenshots/${Date.now()}_error_direct_login.png`})
    }
  }

  cookiesLogin = async () => {
    if(!await fs.existsSync(cookies_path)) { return false }
    await this.logger.say("Performing cookies login")

    const cookiesString = await fs.readFileSync(cookies_path);
    const cookies = JSON.parse(cookiesString);
    await this.page.setCookie(...cookies);

    await this.page.goto(url, { waitUntil: "load" })
    await this.page.waitForSelector('span.signout')
      .then(() => { this.successfulLogin = true })
      .catch(() => { this.successfulLogin = false })

    if(!this.successfulLogin) { await this.logger.warn("Cookies login failed") }
  }

  storeCookies = async () => {
    if(await fs.existsSync(cookies_path)) { await fs.rmSync(cookies_path) }
    const cookies = await this.page.cookies();
    await fs.writeFile(cookies_path, JSON.stringify(cookies, null, 2), () => {  });
  }
}
