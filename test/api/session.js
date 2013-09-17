var should = require('chai').should(),
  server = require('../../server'),
  supertest = require('supertest'),
  api = supertest.agent('http://localhost:1337'),
  utils = require('../utils'),
  testUser = "testUser189",
  password = "password";

before(function(done){
  //start the server and create a test user
  server.start(function(){
    utils.createUser(testUser, password, done);
  });
});


after(function(done){
  //kill the server; delete the test user
  utils.destroyUser(function(){
    server.stop({timeout: 200},done);
  });
});

describe('/login', function() {
  describe('POST - create a new sesssion', function() {

    it('should create a new session', function(done) {
        api.post('/login')
        .set('Content-Type', 'application/json')
        .expect('Content-Type', /json/)
        .send({username: testUser, password:password })
        .expect(200)
        .end(function(err, res){
            res.body.should.have.property('username').and.be.an('string');
            done();
        });
    });
  });

  describe('GET - get the status of the session', function() {
    it('retreive a session', function(done) {
        api.get('/login')
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res){
            res.body.should.have.property('username').and.be.an('string');
            done();
        });
    });
  });

  describe('DELETE - destory the session', function() {
    it('delete a session', function(done) {
        api.del('/login')
        .expect('Content-Type', /json/)
        .expect(200).end(function(err, res){
            res.body.should.have.property('authenticated').that.is.equal(false);
            done()
        })
    });

    it('GET the login status', function(done) {
        api.get('/login')
        .expect('Content-Type', /json/)
        .end(function(err, res){
            res.status.should.equal(200);
            res.body.should.have.property('authenticated').that.is.equal(false);
            done();
        });
    });

  });
});
