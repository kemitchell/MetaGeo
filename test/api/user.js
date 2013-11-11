var should = require('chai').should(),
    supertest = require('supertest'),
    config = require('../config'),
    utils = require('../utils'),
    api = supertest.agent(config.test.url);

describe('/api/user', function() {
    var object_id = null,
        testUser = "testUser8",
        cookie;

    before(function(done) {
        utils.login('B', done);
    });

    describe('POST - a new user', function() {
        it('should return an error invalid fields', function(done) {
            api.post('/api/user')
                .set('Content-Type', 'application/json')
                .send({
                username: testUser,
                password: "testPassword"})
                .expect('Content-Type', /json/)
                .end(function(err, res){
                    res.status.should.equal(400);
                    res.body.should.have.property('fields').and.be.an('object');
                    done();
                });
        });

        it('should create a new user with valid fields', function(done) {
            api.post('/api/user')
                .set('Content-Type', 'application/json')
                .expect('Content-Type', /json/)
                .send({
                username: testUser,
                password: "testPassword",
                email: "asdf@gmail.com"
            })
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('username').and.be.an('string');
                res.body.should.have.property('id').and.be.an('string');
                object_id = res.body.username;
                done();
            });
        });
    });

    describe('GET', function() {
        it('retreive a user', function(done) {
            api.get('/api/user/' + object_id)
                .set('Content-Type', 'application/json')
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('username').and.be.an('string');
                done();
            });
        });
    });

    describe('Login', function() {
        it('retreive a user', function(done) {
            api.post('/api/login')
                .set('Content-Type', 'application/json')
                .expect('Content-Type', /json/)
                .send({
                username: testUser,
                password: "testPassword"
            })
                .end(function(err, res) {
                res.status.should.equal(200);
                res.body.should.have.property('username').and.be.an('string');
                done();
            });
        });
    });

    describe('PUT', function() {
        it('should not be able to be modfied by another user', function(done) {
            utils.B.request.put('/api/user/' + object_id)
                .set('Content-Type', 'application/json')
                .send({
                password: "modiefed password"
            })
                .end(function(err, res) {
                res.status.should.equal(403);
                done();
            });
        });

        it('modify an user', function(done) {
            api.put('/api/user/' + object_id)
                .set('Content-Type', 'application/json')
                .expect('Content-Type', /json/)
                .send({
                password: "modiefed password"
            })
                .end(function(err, res) {
                res.body.should.have.property('username').and.be.an('string');
                done();
            });
        });
    });

    describe('DELETE', function() {
        it('shouldnt be deleted by a differnet user', function(done) {
            utils.B.request.del('/api/user/' + object_id)
                .end(function(err, res) {
                res.status.should.equal(403);
                done();
            });
        });

        it('delete an user', function(done) {
            api.del('/api/user/' + object_id)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                if (err) throw err;
                res.status.should.equal(200);
                done();
            });
        });
    });
});
