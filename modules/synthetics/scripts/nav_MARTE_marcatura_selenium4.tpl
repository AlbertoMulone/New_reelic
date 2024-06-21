var assert = require('assert');

// -------------------- FUNCTIONS
// for backwards compatibility with legacy runtimes
async function waitForAndFindElement(locator) {
  const element = await $webDriver.wait(
    $selenium.until.elementLocated(locator),
    3000,
    "Timed-out waiting for element to be located using: " + locator
  )
  await $webDriver.wait(
    $selenium.until.elementIsVisible(element),
    3000,
    "Timed-out waiting for element to be visible using " + element
  )
  return await $webDriver.findElement(locator)
}

await $webDriver.get("${url}")

// Delete user name
var userTextBlock = await waitForAndFindElement($selenium.By.name('fUSER'))
await userTextBlock.clear().then(function() {
    console.log('Username correctly deleted');
});

// Insert user name
await userTextBlock.sendKeys($secure.${user}).then(function() {
    console.log('Username correctly inserted');
});

// Insert password
const pswTextBlock = await waitForAndFindElement($selenium.By.name('fPSW'))
await pswTextBlock.sendKeys($secure.${pass}).then(function() {
    console.log('Password correctly inserted');
});

// Click "Invia"
const submitButton = await waitForAndFindElement($selenium.By.xpath('//input[@type="submit" and @value= " Invia "]'))
await submitButton.click().then(function() {
    console.log('Click Invia correctly performed');
});

// Verification
userTextBlock = await waitForAndFindElement($selenium.By.name('fUSER')).then(function(){
   console.log('Error page is not displayed');
});
