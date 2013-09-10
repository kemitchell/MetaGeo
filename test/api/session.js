var should = require('chai').should(),
  supertest = require('supertest'),
  api = supertest.agent('http://localhost:1337'),
  utils = require('../utils'),
  testUser = "testUser188",
  password = "password",
  cookie;

before(function(done){
  utils.createUser(testUser, password, done);
});


after(function(done){
  utils.destroyUser(done);
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
    it('retreive a user', function(done) {
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
    it('delete an user', function(done) {
        api.del('/login')
        .expect('Content-Type', /json/)
        .expect(200, done);
    });
  });
});
