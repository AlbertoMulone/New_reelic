const MAX_SKEW = 1000 * 60 * 60 * 24; // 1 day in milliseconds

var options = {
    // Define endpoint URI
    uri: "${url}",
    // Define query key and expected data type.
    headers: {}
};

var assert = require('assert')
var nowDate = new Date(new Date().toDateString()); // align to midnight

$http.get(options, function(err, response, body){
    console.log(response.statusCode + " status code")
    assert.ok(response.statusCode == 200, 'Expected 200 response');

    // example: 03/08/2023 04:30:02 -> 08/03/2023 04:30:02
    var parsedResponse = response.body.slice(3, 5) + "/" + response.body.slice(0, 2) + "/" + response.body.slice(6)

    var responseDate = new Date(parsedResponse);
    responseDate = new Date(responseDate.toDateString()); // align to midnight
  
    console.log("Response date: " + responseDate);
	var dateDifference = nowDate - responseDate;
	console.log("Current skew: " + dateDifference);
	
	assert.ok(MAX_SKEW >= dateDifference, 'Skew is over ' + MAX_SKEW + ' ms: ' + responseDate);
});