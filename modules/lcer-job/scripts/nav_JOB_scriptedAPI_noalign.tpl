const MAX_SKEW = 1000 * 60 * 60 * 3; // 3 hours in milliseconds

var options = {
    // Define endpoint URI
    uri: "${params_map["url"]}",
    // Define query key and expected data type.
    headers: {}
};

var assert = require('assert')
var nowDate = new Date(Date.now()); 

$http.get(options, function(err, response, body){
    console.log(response.statusCode + " status code")
    assert.ok(response.statusCode == 200, 'Expected 200 response');

    // example: 03/08/2023 04:30:02 -> 08/03/2023 04:30:02 GMT+0200
    var parsedResponse = response.body.slice(3, 5) + "/" + response.body.slice(0, 2) + "/" + response.body.slice(6) + " GMT+0200"

    var responseDate = new Date(parsedResponse);
  
    console.log("Response date: " + responseDate);
	var dateDifference = nowDate - responseDate;
	console.log("Current skew: " + dateDifference);
	
	assert.ok(MAX_SKEW >= dateDifference, 'Skew is over ' + MAX_SKEW + ' ms: ' + responseDate);
});