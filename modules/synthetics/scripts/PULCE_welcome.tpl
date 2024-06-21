var assert = require('assert');

//Define your authentication credentials
var options = {
    //Define endpoint URI
    uri: "${url}",
    //Define query key and expected data type.
    headers: {}
};

//Define expected results using callback function.
function callback (err, response, body){
  //Log status code to Synthetics console.
    console.log(response.statusCode + " status code")
  //Verify endpoint returns 401 response code.
    assert.ok(response.statusCode == 401, 'Expected 401 response');
  //Verify that response body contains success message.
    var info = response.body;
    console.log(info);
    assert.ok(info.indexOf("${service_name}") != -1, "Error!");
    console.log('done with script');
}

//Make GET request, passing in options and callback.
$http.get(options,callback);