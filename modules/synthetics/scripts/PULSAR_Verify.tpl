var assert = require('assert');

var options = {
    //Define endpoint URL.
    url: "${url}",
    //Define body of POST request.
    body: '{"dnq": "44345678-1234-1234-1234-012345678966","erc": "1234567890"}',
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
    //Verify that `info` contains element named `is_verified` with a value of `false`.
    assert.ok(info.is_verified == false, 'Code: Expected results not received within Response Body');
    //Log end of script.
    console.log("End reached");
}

//Make POST request, passing in options and callback.
$http.post(options, callback);