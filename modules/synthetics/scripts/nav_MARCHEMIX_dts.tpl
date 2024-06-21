var assert = require('assert');

$browser.get("${url}").then(function(){
// Click DTS Server
  return $browser.findElement($driver.By.linkText('DTS Server')).click().then(function(){
    console.log('Click DTS Server correctly inserted');
  });
}).then(function(){
// Verification 
    return $browser.findElement($driver.By.xpath('//*[text()[contains(.,"${service_name}")]]')).getText().then(function(text){
    console.log('Pattern found: ' + text);
    assert.ok(text.indexOf("${service_name}") != -1, "Error!");
  });
});