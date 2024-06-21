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
// Click "Conferma"
  return $browser.findElement($driver.By.xpath('//input[@type="submit" and @value="Conferma"]')).click().then(function(){
    console.log('Click Entra correctly performed');
  });
}).then(function(){
// Verification 
  return $browser.findElement($driver.By.xpath('//*[text() = "RUNNING"]')).getText().then(function(text){
    assert.ok(text === "RUNNING", "Error!");
    console.log("Pattern found: " + text);
  });
}).then(function(){
// Exit
  return $browser.findElement($driver.By.linkText("Logout")).click().then(function(){
    console.log('Exited correctly');
  });
});