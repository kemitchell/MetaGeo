var should = require('chai').should(),
    utils = require('../utils'),
    config = require('../config');

describe('/login', function() {
    describe('POST - create a new sesssion', function() {
        it('should create a new session', function(done) {
            utils.A.request.post('/login')
            .set('Content-Type', 'application/json')
            .send({
                username: config.A.user.username,
                password: config.A.user.password
            })
            .end(function(err, res) {
                console.log(res.body)
                res.body.should.have.property('username').and.be.an('string');
                res.body.should.have.property('authenticated').that.is.equal(true);
                done();
            });
        });
    });

    describe('GET - get the status of the session', function() {
        it('retreive a session', function(done) {
            utils.A.request.get('/login')
                .expect('Content-Type', /json/)
                .expect(200)
                .end(function(err, res) {
                res.body.should.have.property('username').and.be.an('string');
                res.body.should.have.property('authenticated').that.is.equal(true);
                done();
            });
        });
    });

    describe('DELETE - destory the session', function() {
        it('delete a session', function(done) {
            utils.A.request.del('/login')
            .end(function(err, res) {
                res.body.should.have.property('authenticated').that.is.equal(false);
                done();
            });
        });

        it('GET the login status', function(done) {
            utils.A.request.get('/login')
            .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('authenticated').that.is.equal(false);
                done();
            });
        });
    });
});
