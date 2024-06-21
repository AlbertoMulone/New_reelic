var assert = require('assert');

var optionsAres = {
    url: "${params_map["aresurl"]}",
    headers: {
		'Content-Type': 'text/plain'
    },
	body: $secure.ARES_SYNTH_BODY
};

var optionsIDP = {
	url: "${params_map["idpurl"]}",
	headers: {
		'Content-Type': 'application/x-www-form-urlencoded',
		'Authorization': 'Basic ' + $secure.${params_map["idpcreds"]},
		'Cookie': 'INGRESS_SESSION_ID=1702459341.035.377.882375|f432276428586cbd55ae9233e5259807'
	},
	form: {
		'grant_type': 'client_credentials',
		'scope': 'certificate-update'
	}
}

function callbackAres(error, response, body) {
    // DEBUG: console.log(response.body)
	var parsedReponse = JSON.parse(response.body);
    assert.ok(response.statusCode == 400, 'ARES: expected 400, but got "' + response.body + '"');
	console.log("ARES body: " + response.body);
}

function callbackIDP(error, response, body) {
	assert.ok(response.statusCode == 200, 'IDP: expected 200');
	var parsedResponse = JSON.parse(response.body);
	assert.ok(!parsedResponse.error, 'IDP: failed to authenticate');
	optionsAres.headers["Authorization"] = 'Bearer ' + parsedResponse.access_token;
	$http.put(optionsAres, callbackAres);
}

$http.post(optionsIDP, callbackIDP);