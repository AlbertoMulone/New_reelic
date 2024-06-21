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

// Insert user name
var userTextBlock = await waitForAndFindElement($selenium.By.name('mnse_usr'))
await userTextBlock.sendKeys($secure.${user}).then(function(){
	console.log('Username correctly inserted');
});

// Insert password
const pswTextBlock = await waitForAndFindElement($selenium.By.name('mnse_pwd'))
await pswTextBlock.sendKeys($secure.${pass}).then(function(){
	console.log('Password correctly inserted');
});

// Click "Conferma"
const submitButton = await waitForAndFindElement($selenium.By.xpath('//input[@type="submit" and @value="Conferma"]'))
await submitButton.click().then(function(){
	console.log('Click Conferma correctly performed');
});

// Verification 
const runningText = await waitForAndFindElement($selenium.By.xpath('//*[text() = "RUNNING"]'))
await runningText.getText().then(function(text){
	assert.ok(text === "RUNNING", "Error!");
	console.log("Pattern found: " + text);
});

// Exit
const logoutLink = await waitForAndFindElement($selenium.By.linkText("Logout"))
await logoutLink.click().then(function(){
	console.log('Exited correctly');
});