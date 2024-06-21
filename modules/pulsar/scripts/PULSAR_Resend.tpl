var assert = require('assert');

var options = {
    //Define endpoint URL.
    url: "${params_map["url"]}",
    //Define body of POST request.
    body: '{"dnq": "14897670-0411-2261-8239-443730441210","userid": "userid", "notification": {"emailAddress": "xxx.yyy@infocert.it","passphrase": "12345678","template": "erc_it"}}',
    //Define insert key and expected data type.
    headers: {
        'Content-Type': 'application/json'
        }
};

//Define expected results using callback function.
function callback(error, response, body) {
    //Log status code to Synthetics console.
    console.log(response.statusCode + " status code")
    //Verify endpoint returns 200 (OK) response code.
    assert.ok(response.statusCode == 200, 'Expected 200 OK response');
    //Parse JSON received from Insights into variable.
    var info = JSON.parse(body);
    console.log(info);
    //Verify that `info` contains element named `envelopeId` with a value of `aWaYrPBEuCHPnCPxgH4a`.
    assert.ok(info.envelopeId == 'aWaYrPBEuCHPnCPxgH4a', 'Code: Expected results not received within Response Body');
    //Log end of script.
    console.log("End reached");
}

//Make POST request, passing in options and callback.
$http.post(options, callback);