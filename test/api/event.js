var should = require('chai').should(),
    config = require("../config");
    utils = require('../utils');

describe('/event', function() {
    var event_id = null;

    before(function(done) {
        utils.createUser(done);
    });

    after(function(done) {
        utils.destroyUser(done);
    });

    describe("POST - create a new event", function() {
        it('create a new event with invalid fields', function(done) {
            utils.request.post('/event')
            .end(function(err, res) {
                res.status.should.equal(401);
                done();
            });
        });

        it('login', function(done) {
            utils.login(done);
        });

        it('create a new event with valid fields', function(done) {
            utils.request.post( '/event')
                .set('Content-Type', 'application/json')
                .send({
                title: "testtr89",
                content: "testContent",
                start: new Date(),
                lat: 34,
                lng: -90
            })
            .end(function(err, res) {
                console.log(res.body);
                res.status.should.equal(200);
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                event_id = res.body.id;
                done();
            });
        });
    });

    describe("GET - retrieve an event", function() {
        it('get without an ID', function(done) {
            utils.request.get( '/event')
                .set('Content-Type', 'application/json')
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('items').and.be.an('array');
                done();
            });
        });

        it('retreive an event', function(done) {
            utils.request.get('/event/' + event_id)
                .set('Content-Type', 'application/json')
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                done();
            });
        });
    });

    describe("PUT - modiy an event", function() {
        it('modify an event', function(done) {
            utils.request.put('/event/' + event_id)
                .set('Content-Type', 'application/json')
                .send({
                title: "testEventModified",
                "time": new Date(),
                content: "testContentModified"
            })
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                done();
            });
        });
    });

    describe("DELETE - delete an event", function() {
        it('delete an event', function(done) {
            utils.request.del('/event/' + event_id)
                .end(function(err, res) {
                res.status.should.equal(200);
                done();
            });
        });
    });
});
