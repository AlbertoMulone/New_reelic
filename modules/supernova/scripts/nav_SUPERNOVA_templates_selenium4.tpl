var assert = require('assert');

// -------------------- FUNCTIONS
// for backwards compatibility with legacy runtimes
async function waitForAndFindElement(locator, timeout) {
  const element = await $webDriver.wait(
    $selenium.until.elementLocated(locator),
    timeout,
    "Timed-out waiting for element to be located using: " + locator
  )
  await $webDriver.wait(
    $selenium.until.elementIsVisible(element),
    timeout,
    "Timed-out waiting for element to be visible using " + element
  )
  return await $webDriver.findElement(locator)
}

await $webDriver.get("${params_map["url"]}")

// Click Login
const loginButton = await $webDriver.findElement($selenium.By.id('btn-authentication-login'))
await loginButton.click().then(function(){
	console.log('Login clicked');
});

// Insert username
const userTextBlock = await $webDriver.findElement($selenium.By.id('username'))
await userTextBlock.sendKeys($secure.${params_map["user"]}).then(function(){
	console.log('Username correctly inserted');
});

// Insert password
const pswTextBlock = await $webDriver.findElement($selenium.By.id('password'))
await pswTextBlock.sendKeys($secure.${params_map["pass"]}).then(function(){
	console.log('Password correctly inserted');
});

// Login
const kcloginButton = await $webDriver.findElement($selenium.By.id('kc-login'))
await kcloginButton.click().then(function(){
	console.log('Login done');
});

// Click on Templates
const templatesLink = await waitForAndFindElement($selenium.By.partialLinkText("Templates"), 4000)
await templatesLink.click().then(function(text){
	console.log('Templates clicked');
});

// Verification 
const infocertText = await waitForAndFindElement($selenium.By.xpath('//*[text() = "INFOCERT"]'), 8000)
await infocertText.getText().then(function(text){
	assert.ok(text === "INFOCERT", "Error!");
	console.log("Pattern found: " + text);
});

// Logout1
const logout1Link = await $webDriver.findElement($selenium.By.partialLinkText("${params_map["validation_string"]}"))
await logout1Link.click().then(function(){
	console.log('Logout phase 1');
});

// Logout2
const logout2Button = await $webDriver.findElement($selenium.By.id("btn-authentication-logout"))
await logout2Button.click().then(function(){
	console.log('Logout phase 2');
});
