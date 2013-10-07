var should = require('chai').should(),
    config = require("../config");
    utils = require('../utils');

describe('/event', function() {
    var event_id = null;

    after(function(done){
        utils.logout(done);
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

        it('create a new event with valid fields without an objectType', function(done) {
            utils.request.post( '/event')
                .set('Content-Type', 'application/json')
                .send({
                content: "testContent",
                lat: 34,
                lng: -90
            })
            .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                res.body.should.have.property('objectType').and.be.equal('mblog');
                event_id = res.body.id;
                done();
            });
        });

        it('create a new socail event', function(done) {
            utils.request.post( '/event/social')
                .set('Content-Type', 'application/json')
                .send({
                title: "testtr89",
                content: "testContent",
                start: new Date(),
                lat: 34,
                lng: -90
            })
            .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                res.body.should.have.property('objectType').and.be.equal('social');
                done();
            });
        });
    });

    describe("GET - retrieve an event", function() {
        it('get without an ID', function(done) {
            utils.request.get( '/event/')
                .set('Content-Type', 'application/json')
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('items').and.be.an('array');
                done();
            });
        });

        it('retreive an event', function(done) {
            console.log('/event/' + event_id)
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
