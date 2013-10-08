var should = require('chai').should(),
    config = require("../config"),
    utils = require('../utils');

describe('/events/', function() {

    before(function(done) {
        utils.createRandomEvents(30, config.test.boundsA, done)
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

    it('get events inside a bounds A', function(done) {
        var bounds = config.test.boundsA
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1]
        utils.request.get('/events/?box='+bounds)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(30)
            done();
        });
    });

    it('get events inside a bounds B', function(done) {
        var bounds = config.test.boundsB
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1]
        utils.request.get('/events/?box='+bounds)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(0)
            done();
        });
    });

    it('get events inside a with title of test_2', function(done) {
        utils.request.get('/events/?title=test_2')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(1)
            done();
        });
    });

});
