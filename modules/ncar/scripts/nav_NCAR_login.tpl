var assert = require('assert');

// -------------------- FUNCTIONS
// for backwards compatibility with legacy runtimes
async function waitForAndFindElement(locator) {
  const element = await $webDriver.wait(
    $selenium.until.elementLocated(locator),
    6000,
    "Timed-out waiting for element to be located using: " + locator
  )
  await $webDriver.wait(
    $selenium.until.elementIsVisible(element),
    6000,
    "Timed-out waiting for element to be visible using " + element
  )
  return await $webDriver.findElement(locator)
}

await $webDriver.get("${params_map["url"]}")

// Switch to the frame
const carnFrame = await waitForAndFindElement($selenium.By.id('frameDisplayCarn'))
await $webDriver.switchTo().frame(carnFrame)

// Insert user name
var userTextBlock = await waitForAndFindElement($selenium.By.name('username'))
await userTextBlock.sendKeys($secure.${params_map["user"]}).then(function(){
	console.log('Username correctly inserted');
});

// Insert password
const pswTextBlock = await waitForAndFindElement($selenium.By.name('password'))
await pswTextBlock.sendKeys($secure.${params_map["pass"]}).then(function(){
	console.log('Password correctly inserted');
});

// Click "Conferma"
const submitButton = await waitForAndFindElement($selenium.By.xpath('//input[@type="submit"]'))
await submitButton.click().then(function(){
	console.log('Click Conferma correctly performed');
});

// Verification
const verifyText = await waitForAndFindElement($selenium.By.xpath('//*[contains(@class, "titolo") and text() = "INFORMAZIONI GENERALI SULLA RA"]'))
await verifyText.getText().then(function(text){
	assert.ok(text === "INFORMAZIONI GENERALI SULLA RA", "Error!");
	console.log("Pattern found: " + text);
});

// Click "Sottoscrizione"
const subscriptionLink = await waitForAndFindElement($selenium.By.linkText("Sottoscrizione"))
await subscriptionLink.click().then(function(){
	console.log('Click Sottoscrizione correctly performed');
});

// Verification
const verify2Text = await waitForAndFindElement($selenium.By.xpath('//*[contains(@class, "mnpTableTitle") and text() = "Residenza"]'))
await verify2Text.getText().then(function(text){
	assert.ok(text === "Residenza", "Error!");
	console.log("Pattern found: " + text);
});

// Click "Home"
const homeLink = await waitForAndFindElement($selenium.By.linkText("Home"))
await homeLink.click().then(function(){
	console.log('Click Home correctly performed');
});

// Verification
const verify3Text = await waitForAndFindElement($selenium.By.xpath('//*[contains(@class, "titolo") and text() = "INFORMAZIONI GENERALI SULLA RA"]'))
await verify3Text.getText().then(function(text){
	assert.ok(text === "INFORMAZIONI GENERALI SULLA RA", "Error!");
	console.log("Pattern found: " + text);
});

// Exit
const logoutLink = await $webDriver.findElement($selenium.By.linkText("Esci"))
await logoutLink.click().then(function(){
	console.log('Exited correctly');
});
