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

await $urlFilter.addToDenyList(['cdn.cookielaw.org', 'www.googletagmanager.com', 'googlesyndication.com', 'servedby.revive-adserver.net', 'prompts.maze.co', 'snippet.maze.co'])

await $webDriver.get("${params_map["url"]}")

// Click login button
const loginButton = await waitForAndFindElement($selenium.By.xpath("(//*[@class='login-button'])/button"))
await loginButton.click().then(function(){
	console.log('Click Login correctly performed');
});

// Insert user name
const userTextBlock = await waitForAndFindElement($selenium.By.xpath("//*[@id='icIdName']"))
await userTextBlock.sendKeys($secure.${params_map["user"]}).then(function(){
	console.log('Username correctly inserted');
});

// Insert password
const pswTextBlock = await waitForAndFindElement($selenium.By.xpath("//*[@id='icIdPassword']"))
await pswTextBlock.sendKeys($secure.${params_map["pass"]}).then(function(){
	console.log('Password correctly inserted');
});

// Click "Accedi"
const submitButton = await waitForAndFindElement($selenium.By.xpath("//*[@type='button'][text()[contains(.,'Accedi')]]"))
await submitButton.click().then(function(){
	console.log('Click Accedi correctly performed');
});

// Wait max 6 sec and verify landing page 
const landingPageText = await waitForAndFindElement($selenium.By.xpath('//*[text()[contains(.,"Signature certificate")]]'))
await landingPageText.getText().then(function(text){
	assert.ok(text.indexOf("Signature certificate") != -1, "Error!");
	console.log("Pattern found: " + text);
});

// Click to exit
const userInfoDrop = await waitForAndFindElement($selenium.By.xpath('//*[@class="ic1-user-dropdown-container"]'))
await userInfoDrop.click().then(function(){
	console.log('Click to Exit correctly performed');
});

// Exit
const logoutLink = await $webDriver.findElement($selenium.By.xpath('//*[text()[contains(.,"Get out")]]'))
await logoutLink.click().then(function(){
	console.log('Exited correctly');
});