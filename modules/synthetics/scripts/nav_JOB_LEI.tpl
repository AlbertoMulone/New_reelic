var assert = require('assert');
const date = new Date();

const day = date.getDate();
const month = date.getMonth() + 1;
const year = date.getFullYear();

var datestring = ("0" + date.getDate()).slice(-2) + "/" + ("0"+(date.getMonth()+1)).slice(-2) + "/" + date.getFullYear();

console.log("Date pattern: " + datestring)

$browser.get("${url}").then(function(){
// Verifying that last execution has been made today
  return $browser.findElement($driver.By.xpath('//*[text()[contains(.,datestring)]]')).getText().then(function(text){
    if( text.indexOf(datestring) >= 0){
      assert.ok;
      console.log("Pattern found: " + text);
    }else{
      assert.ok(false);
    }
  });
});