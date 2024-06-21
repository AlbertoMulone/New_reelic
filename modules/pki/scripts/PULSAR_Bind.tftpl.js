var assert = require('assert');

var options = {
    //Define endpoint URL.
    url: "${lookup(params_map, "url", "")}",
    //Define body of POST request.
    body: '{"dnqs":["12345678-0411-2261-8239-443730441210"],"device":"1234567890123456","notification": {"emailAddress": "xxx.yyy@infocert.it","passphrase": "taxcode","template": "erc_es"}}',
    //Define insert key and expected data type.
    headers: {
        'Content-Type': 'application/json'
        }
};

//Define expected results using callback function.
function callback(error, response, body) {
    //Log status code to Synthetics console.
    console.log(response.statusCode + " status code")
    //Verify endpoint returns 412 (OK) response code.
    assert.ok(response.statusCode == 412, 'Expected 412 Precondition Failed');
    //Parse JSON received from Insights into variable.
    var info = JSON.parse(body);
    console.log(info);
    //Verify that `info` contains element named `code` with a value of `Precondition`.
    assert.ok(info.code == 'Precondition', 'Code: Expected results not received within Response Body');
    //Verify that `info` contains element named `message` with a value of `Entry already present`.
    assert.ok(info.message == 'Entry already present', 'Message: Expected results not received within Response Body');
    //Log end of script.
    console.log("End reached");
}

//Make POST request, passing in options and callback.
$http.post(options, callback);
