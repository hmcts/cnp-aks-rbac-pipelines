const CDP = require("chrome-remote-interface");
const puppeteer = require("puppeteer-core");
const { spawn } = require("child_process");

if (process.argv.length !== 3) {
  process.exit(1)
}

const credentialsPath = process.argv[2]
const credentials = require(credentialsPath)

const kubeCtl = spawn("kubectl", ["get", "pods"]);

kubeCtl.stdout.on("data", data => {
  console.log(`stdout: ${data}`);
});

kubeCtl.stderr.on("data", async data => {
  let page, browser;

  console.log(`stderr: ${data}`);

  const code = data
    .toString()
    .split("code")[1]
    .substring(1, 10);


  if (!code) {
    return process.exit(1)
  }


  try {
    const cdpVersion = await CDP.Version();
    console.log(`${cdpVersion.webSocketDebuggerUrl}`);

    browser = await puppeteer.connect({
      browserWSEndpoint: cdpVersion.webSocketDebuggerUrl
    });

    page = await browser.newPage();

    await page.goto(`https://microsoft.com/devicelogin`, {
      waitUntil: "domcontentloaded"
    });

    await page.click("#code");
    await page.keyboard.type(code);
    await page.waitFor(2000);
    await page.click("#continueBtn");
    await page.waitFor(2000);
    // await page.click("#otherTileText");
    // await page.waitFor(2000);
    await page.click("input[type=email]");
    await page.waitFor(2000);
    await page.keyboard.type(credentials.email);
    await page.waitFor(1000);
    await page.click("#idSIButton9");
    await page.waitFor(1000);
    await page.click("input[type=password]");
    await page.waitFor(1000);
    await page.keyboard.type(credentials.password);
    await page.waitFor(1000);
    await page.click("#idSIButton9");
  } catch (err) {
    console.error(err);
  }
});

kubeCtl.on("close", code => {
  console.log(`child process exited with code ${code}`);
  process.exit(code)
});
