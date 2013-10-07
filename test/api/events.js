var should = require('chai').should(),
    config = require("../config"),
    utils = require('../utils');

describe('/events/', function() {

    before(function(done) {
        utils.createRandomEvents(30, config.test.bounds, done)
        //utils.createRandomEvents(200, config.test.bounds2)
    });

    it('get a list of events', function(done) {
        utils.request.get('/events/')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(30)
            done();
        });
    });
});
