var should = require('chai').should(),
    config = require("../config"),
    utils = require('../utils');

describe('/events/', function() {
    it('get a list of events', function(done) {
        utils.request.get('/events/')
        .set('Content-Type', 'application/json')
        .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            done();
        });
    });

});
