var assert = require('assert');

var options = {
    //Define endpoint URL.
    url: "${url}",
    //Define body of POST request.
    body: '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:reg="http://reg.webservice.infora.infocert.it/"><soapenv:Header/><soapenv:Body><reg:interrogazione><contesto>20236000031</contesto><modoRicerca>3</modoRicerca></reg:interrogazione></soapenv:Body></soapenv:Envelope>',
    //Define insert key and expected data type.
    headers: {
        'Content-Type': 'text/xml',
        // 'Accept-Encoding': 'gzip,deflate',
        'Authorization': 'Basic ${authorization}'
        }
};

//Define expected results using callback function.
function callback(error, response, body) {
    //Log status code and response to Synthetics console.
    console.log(response.statusCode + " status code")
    console.log(response.body)
    //Verify endpoint returns ${code} response code.
    assert.ok(response.statusCode == ${code}, 'Expected ${code}');
    //Verify that response contains expected identifier.
    assert.ok(response.body.indexOf("${check_string}") != -1, "'Message: Expected identifier ${check_string} not received within Response Body'");
    //Log end of script.
    console.log("End reached");
}

//Make POST request, passing in options and callback.
$http.post(options, callback);