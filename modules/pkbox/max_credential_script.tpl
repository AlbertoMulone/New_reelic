var assert = require('assert');
var max, act;

$browser.get("${url}").then(function(){
  return $browser.findElement($driver.By.xpath("/html/body/form/table[3]/tbody/tr[7]/td[2]/b")).getText().then(function (text) {
    console.log("max:" + text);
    max = text;
    return $browser.findElement($driver.By.xpath("/html/body/form/table[3]/tbody/tr[8]/td[2]/b")).getText().then(function (text) {
      console.log("act:" + text);
      act = text;
      var usage = Math.trunc((parseInt(act)/parseInt(max) * 100))
      console.log('usage: ' + usage + '%');
      assert.ok(usage < ${max_credentials_limit}, "usage " + usage + " is over ${max_credentials_limit}!");
    });
  });
});
