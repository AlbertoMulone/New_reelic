var assert = require('assert');

var options = {
    //Define endpoint URL.
    url: "${url}",
    //Define query key and expected data type.
    headers: {}
};

//Define expected results using callback function.
function callback(error, response, body) {
    //Log status code to Synthetics console.
    console.log(response.statusCode + " status code")
    //Verify endpoint returns ${status_code} response code.
    assert.ok(response.statusCode == ${status_code}, 'Expected ${status_code} OK response');
    //Verify that response body contains success message.
    var info = response.body;
    console.log(info);
    assert.ok(info.indexOf("${check_response}") != -1, "Error!");
    //Log end of script.
    console.log("End reached");
}

//Make GET request, passing in options and callback.
$http.get(options,callback);