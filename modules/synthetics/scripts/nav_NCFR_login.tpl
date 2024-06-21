var assert = require('assert');

$browser.get("${url}").then(function(){
// Insert user name
  return $browser.findElement($driver.By.name('mnse_usr')).sendKeys($secure.${user}).then(function(){
    console.log('Username correctly inserted');
  });
}).then(function(){
// Insert password
  return $browser.findElement($driver.By.name('mnse_pwd')).sendKeys($secure.${pass}).then(function(){
    console.log('Password correctly inserted');
  });
}).then(function(){
// Click "Entra"
  return $browser.findElement($driver.By.xpath('//input[@type="image"]')).click().then(function(){
    console.log('Click Entra correctly performed');
  });
}).then(function(){
// Verification 
  return $browser.findElement($driver.By.xpath('//*[text() = " Gestione del servizio Remote Sign"]')).getText().then(function(text){
    assert.ok(text === "Gestione del servizio Remote Sign", "Error!");
    console.log("Pattern found: " + text);
  });
}).then(function(){
// Exit
  return $browser.findElement($driver.By.xpath('//img[@src="img/logout.png"]')).click().then(function(){
    console.log('Exited correctly');
  });
});