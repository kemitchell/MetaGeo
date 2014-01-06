var should = require('chai').should(),
    config = require("../config"),
    utils = require('../utils');

describe('/api/event', function() {
    var mblog_event_id = null;
    var social_event_id = null;

    before(function(done){
        utils.login('B', done);
    });

    after(function(done){
        utils.logout(done);
    });

    describe("POST - create a new event", function() {
        it('create a new event with invalid fields', function(done) {
            utils.A.request.post('/api/event')
            .end(function(err, res) {
                //forbidden
                res.status.should.equal(401);
                done();
            });
        });

        it('login', function(done) {
            utils.login('A',done);
        });

        it('create a new mblog event', function(done) {
            utils.A.request.post( '/api/event/mblog')
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
                mblog_event_id = res.body.id;
                done();
            });
        });

        it('create a new social event', function(done) {
            utils.A.request.post( '/api/event/social')
                .set('Content-Type', 'application/json')
                .send({
                title: "testtr89t",
                content: "testContent",
                start: (new Date()).toJSON(),
                end: (new Date()).toJSON(),
                address: "test address",
                venue: "test venue",
                lat: 34,
                lng: -90
            })
            .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                res.body.should.have.property('objectType').and.be.equal('social');

                res.body.should.have.property('start').and.be.an('string');
                res.body.should.have.property('end').and.be.an('string');
                res.body.should.have.property('address').and.be.an('string');
                res.body.should.have.property('venue').and.be.an('string');

                social_event_id = res.body.id;
                done();
            });
        });
    });

    describe("GET - retrieve an event", function() {
        it('retreive an event', function(done) {
            utils.A.request.get('/api/event/' + mblog_event_id)
                .set('Content-Type', 'application/json')
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                done();
            });
        });
    });

    describe("PUT - modify an event", function() {
        it('should not be able to be modfied by another user', function(done) {
            utils.B.request.put('/api/event/' + social_event_id)
                .set('Content-Type', 'application/json')
                .send({
                title: "testEventModified",
                content: "testContentModified"
            })
                .end(function(err, res) {
                res.status.should.equal(403);
                done();
            });
        });

        it('should not be able to be modfiy the objectType', function(done) {
            utils.A.request.put('/api/event/' + social_event_id)
                .set('Content-Type', 'application/json')
                .send({
                objectType: "TestType",
                content: "testContentModified"
            })
                .end(function(err, res) {
                res.body.objectType.should.equal('social');

                done();
            });
        });

        it('modify an event', function(done) {
            utils.A.request.put('/api/event/' + social_event_id)
                .set('Content-Type', 'application/json')
                .send({
                title: "testEventModified",
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

    describe("DELETE", function() {
        it('shouldnt be deleted by a differnet user', function(done) {
            utils.B.request.del('/api/event/' + mblog_event_id)
                .end(function(err, res) {
                res.status.should.equal(403);
                done();
            });
        });

        it('delete a mblog event', function(done) {
            utils.A.request.del('/api/event/' + mblog_event_id)
                .end(function(err, res) {
                res.status.should.equal(200);
                done();
            });
        });

        it('delete a social event', function(done) {
            utils.A.request.del('/api/event/' + social_event_id)
                .end(function(err, res) {
                res.status.should.equal(200);
                done();
            });
        });
    });
});
