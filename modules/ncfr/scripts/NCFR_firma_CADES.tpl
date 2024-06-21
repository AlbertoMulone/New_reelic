var assert = require('assert');

var options = {
    //Define endpoint URL.
    url: "${params_map["url"]}",
    //Define body of POST request.
    body: '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fir="http://firma.fr.webservice.ncfr.infocert.it/"><soapenv:Header/><soapenv:Body><fir:firmaCADES><documentoDaFirmare>VW4gZG9jdW1lbnRvIHZhbGUgbCdhbHRyby4uIG8gbm8/</documentoDaFirmare><dominio>FMASICE</dominio><alias>TSTSND70A01G224X</alias><pin>15022016</pin><otp/></fir:firmaCADES></soapenv:Body></soapenv:Envelope>',
    //Define insert key and expected data type.
    headers: {
        'Authorization': 'Basic SjFVUkFPUzpCYnRnNUpTUA==',
        'Content-Type': 'text/xml'
        }
};

//Define expected results using callback function.
function callback(error, response, body) {
    //Log status code to Synthetics console.
    console.log(response.statusCode + " status code")
    //Verify endpoint returns 200 (OK) response code.
    assert.ok(response.statusCode == 200, 'Expected 200 OK response');
    //Verify that response body contains success message.
    var info = response.body;
    console.log(info);
    assert.ok(info.indexOf("${params_map["validation_string"]}") != -1, "Error!");
    //Log end of script.
    console.log("End reached");
}

//Make POST request, passing in options and callback.
$http.post(options, callback);