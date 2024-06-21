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

// Insert user name
const userTextBlock = await waitForAndFindElement($selenium.By.xpath("(//*[@id='username'])[2]"))
await userTextBlock.sendKeys($secure.${params_map["user"]}).then(function(){
	console.log('Username correctly inserted');
});

// Insert password
const pswTextBlock = await waitForAndFindElement($selenium.By.xpath("(//*[@id='password'])[2]"))
await pswTextBlock.sendKeys($secure.${params_map["pass"]}).then(function(){
	console.log('Password correctly inserted');
});

// Click "Conferma"
const submitButton = await waitForAndFindElement($selenium.By.xpath("(//*[@type='submit'])"))
await submitButton.click().then(function(){
	console.log('Click Conferma correctly performed');
});

// Wait max 6 sec and verify landing page 
const landingPageText = await waitForAndFindElement($selenium.By.xpath('//*[text()[contains(.,"Certificato di firma")]]'))
await landingPageText.getText().then(function(text){
	assert.ok(text.indexOf("Certificato di firma") != -1, "Error!");
	console.log("Pattern found: " + text);
});

// Click to exit
const userInfoDrop = await waitForAndFindElement($selenium.By.xpath('//*[@class="ic1-user-info-title"]'))
await userInfoDrop.click().then(function(){
	console.log('Click to Exit correctly performed');
});

// Exit
const logoutLink = await $webDriver.findElement($selenium.By.xpath('//*[text()[contains(.,"Esci")]]'))
await logoutLink.click().then(function(){
	console.log('Exited correctly');
});
