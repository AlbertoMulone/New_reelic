var assert = require('assert');

$browser.get("https://www.firma.infocert.it/utenti/").then(function(){
// Verification 1
  return $browser.findElement($driver.By.xpath('*//h1[text()[contains(.,"I servizi per i titolari della firma digitale")]]')).getText().then(function(text){
    console.log("Pattern found: " + text);
    $browser.takeScreenshot();
    assert.ok(text.indexOf("I servizi per i titolari della firma digitale") != -1, "Error!");
  });
}).then(function(){
  // Verification 2
  return $browser.findElement($driver.By.xpath('*//a[text()="Sospensione"]')).getText().then(function(text){
    console.log("Pattern found: " + text);
    assert.ok(text === "Sospensione", "Error!");
  }); 
}).then(function(){
  // Click "Sospensione"
  return $browser.findElement($driver.By.xpath('*//a[text()="Sospensione"]')).click().then(function(){
    console.log('Click Sospensione correctly performed');
  });
}).then(function(){
// Click "richiestra di sospensione"
  return $browser.findElement($driver.By.xpath('*//a[@href="/pdf/Modulo_Richiesta_Sospensione.pdf"]')).click().then(function(){
    console.log('Click richiesta di sospensione correctly performed');
  });
}).then(function(){
// Go back to previous page
  return $browser.navigate().back().then(function(){
    console.log('Gone back to previous page');
  });
}).then(function(){
// Click "richiestra di sospensione terzo interessato"
  return $browser.findElement($driver.By.xpath('*//a[@href="/pdf/Modulo_Richiesta_Sospensione_Terzo_Interessato.pdf"]')).click().then(function(){
    console.log('Click richiesta di sospensione terzo interessato correctly performed');
  });
}).then(function(){
// Go back to previous page
  return $browser.navigate().back().then(function(){
    console.log('Gone back to previous page');
  });
}).then(function(){
// Click "Call Center"
  return $browser.findElement($driver.By.linkText("Call Center")).click().then(function(){
    console.log('Click Call Center correctly performed');
  });
}).then(function(){
// Go back to previous page
  return $browser.navigate().back().then(function(){
    console.log('Gone back to previous page');
  });
}).then(function(){
  // Click "Sospensione"
  return $browser.findElement($driver.By.xpath('*//a[text()="Sospensione"]')).click().then(function(){
    console.log('Click Sospensione correctly performed');
  });
}).then(function(){
// Click "modalità online"
  return $browser.findElement($driver.By.linkText("modalità online")).click().then(function(){
    console.log('Click modalità online correctly performed');
  });
}).then(function() {
// Insert IUT
  return $browser.findElement($driver.By.name('fIUT')).sendKeys("20091111111").then(function(){
    console.log('IUT correctly inserted');
  });
}).then(function(){
// Insert ERC
  return $browser.findElement($driver.By.name('fPUK')).sendKeys("1234567890").then(function(){
    console.log('ERC correctly inserted');
  });
}).then(function() {
// Re-insert ERC
  return $browser.findElement($driver.By.name('fPUKr')).sendKeys("1234567890").then(function(){
    console.log('ERC correctly re-inserted');
  });
}).then(function(){
// Insert date
  return $browser.findElement($driver.By.name('fDT_FINE_SOS')).sendKeys("01/01/2020").then(function(){
    console.log('Date correctly inserted');
  });
});