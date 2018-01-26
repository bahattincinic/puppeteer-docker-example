const express = require('express');
const puppeteer = require('puppeteer');

const app = express();

app.get('/screenshot', async (req, res) => {
  const browser = await puppeteer.launch({
    executablePath: 'google-chrome-unstable',
    args: ['--disable-gpu', '--no-sandbox', '--single-process',  '--disable-web-security']
  });

  const page = await browser.newPage();

  await page.setJavaScriptEnabled(true);
  await page.goto(req.query.url);

  const screenshot = await page.screenshot({ type: 'jpeg', quality: 95 });
  await browser.close();

  res.end(screenshot);
})

app.listen(4000, () => console.log('listening on port 4000!'));
