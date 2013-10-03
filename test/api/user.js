var should = require('chai').should(),
  supertest = require('supertest'),

  utils = require('../utils');
  api = utils.request 

describe('/user', function() {
  var object_id = null; 
  var testUser = "testUser9";

  describe('POST - a new user', function() {
    it('should return an error invalid fields', function(done) {
        api.post('/user')
        .set('Content-Type', 'application/json')
        .expect('Content-Type', /json/)
        .expect(400, done)
    });

    it('should create a new user with valid fields', function(done) {
        api.post('/user')
        .set('Content-Type', 'application/json')
        .expect('Content-Type', /json/)
        .send({username: testUser, password:"testPassword" })
        .expect(200)
        .end(function(err, res){
            res.body.should.have.property('username').and.be.an('string');
            res.body.should.have.property('id').and.be.an('string');
            object_id = res.body.id;
            done();
        });
    });
  });

  describe('GET', function() {
    it('retreive a user', function(done) {
        api.get('/user/' + object_id)
        .set('Content-Type', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res){
            res.body.should.have.property('username').and.be.an('string');
            done();
        });
    });
  });

  describe('PUT', function() {
    it('modify an user', function(done) {
        api.put('/user/' + object_id)
        .set('Content-Type', 'application/json')
        .expect('Content-Type', /json/)
        .send({password: "modiefed password" })
        .end(function(err, res){
            res.body.should.have.property('username').and.be.an('string');
            done();
        });
    });
  });

  describe('DELETE', function() {
    it('delete an user', function(done) {
        api.del('/user/' + object_id)
        .expect('Content-Type', /json/)
        .expect(200)
        .end(function(err, res){
            if(err) throw err;
            done();
        });
    });
  });
});
