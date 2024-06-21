var assert = require('assert');

$browser.get("${url}").then(function(){
// Click Login
  return $browser.findElement($driver.By.id('btn-authentication-login')).click().then(function(){
    console.log('Login clicked');
  });
}).then(function(){
// Insert username
  return $browser.findElement($driver.By.id('username')).sendKeys($secure.${user}).then(function(){
    console.log('Username correctly inserted');
  });
}).then(function(){
// Insert password
  return $browser.findElement($driver.By.id('password')).sendKeys($secure.${pass}).then(function(){
    console.log('Password correctly inserted');
  });
}).then(function(){
// Login
  return $browser.findElement($driver.By.id('kc-login')).click().then(function(){
    console.log('Login done');
  });
}).then(function(){
// Click on Templates
  return $browser.findElement($driver.By.partialLinkText("Templates")).click().then(function(text){
    console.log('Templates clicked');
  });
}).then(function(){
// Verification 
  return $browser.waitForAndFindElement($driver.By.xpath('//*[text() = "INFOCERT"]'), 5000).getText().then(function(text){
    assert.ok(text === "INFOCERT", "Error!");
    console.log("Pattern found: " + text);
  });
}).then(function(){
// Logout1
  return $browser.findElement($driver.By.partialLinkText("${service_name}")).click().then(function(){
    console.log('Logout phase 1');
  });
}).then(function(){
// Logout2
  return $browser.findElement($driver.By.id("btn-authentication-logout")).click().then(function(){
    console.log('Logout phase 2');
  });
});