var assert = require('assert');

$browser.get("${url}").then(function(){
// Verification 
    return $browser.findElement($driver.By.xpath('//*[text()[contains(.,"${service_name}")]]')).getText().then(function(text){
    console.log('Pattern found: ' + text);
    assert.ok(text.indexOf("${service_name}") != -1, "Error!");
  });
});