var assert = require('assert');
$browser.get("${url}").then(function(){
  return $browser.findElement($driver.By.xpath('//*[text() = "Prenotazione richiesta registrazione"]')).getText().then(function(text){
    assert.ok(text === "Prenotazione richiesta registrazione", "Error!");
    console.log("Pattern found: " + text);
  });
});