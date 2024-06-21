$browser.get("${url}").then(function(){
  return $browser.findElement($driver.By.xpath('//*[contains(@class, "html-attribute-value") and text() = "${service_name}"]')).getText().then(function(text){
    console.log("Service name: " + text);
  });
});
