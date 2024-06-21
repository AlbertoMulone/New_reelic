var assert = require('assert');

var options = {
    url: "${params_map["url"]}",
    form: {
		'fUSER': $secure.${params_map["user"]},
        'fPSW': $secure.${params_map["pass"]},
        'fTIPO': 'HASH-MARCA',
        'fHASH': '92A970FA85064B97CD77A76AC0E663CD2990D6ADC274E3AA2D01F832D43A8299'
    }
};

function callback(error, response, body) {
    // DEBUG: console.log(response.body)
    assert.ok(response.statusCode == 200, 'Expected 200');
    assert.ok(response.body.indexOf("ERRNO=") == -1, 'Message: request failed, ERRNO returned');
    console.log("End reached");
}

$http.post(options, callback);