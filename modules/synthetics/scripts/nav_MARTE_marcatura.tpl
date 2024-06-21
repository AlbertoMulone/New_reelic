var assert = require('assert');

$browser.get("${url}").then(function(){
// Delete user name
  return $browser.findElement($driver.By.name('fUSER')).clear().then(function(){
    console.log('Username correctly deleted');
  });
}).then(function(){
// Insert user name
  return $browser.findElement($driver.By.name('fUSER')).sendKeys($secure.${user}).then(function(){
    console.log('Username correctly inserted');
  });
}).then(function(){
// Insert password
  return $browser.findElement($driver.By.name('fPSW')).sendKeys($secure.${pass}).then(function(){
    console.log('Password correctly inserted');
  });
}).then(function(){
// Click "Invia"
  return $browser.findElement($driver.By.xpath('//input[@type="submit" and @value= " Invia "]')).click().then(function(){
    console.log('Click Invia correctly performed');
  });
}).then(function(){
// Verification 
  return $browser.findElement($driver.By.name('fUSER')).then(function(){
   console.log('Error page is not dispayed');
  });
});