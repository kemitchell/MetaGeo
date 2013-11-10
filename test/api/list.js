var should = require('chai').should(),
    utils = require('../utils'),
    object_id = null;

describe('/api/list', function() {

    before(function(done){
        utils.login('B', done);
    });
    
    after(function(done){
        utils.logout(done);
    });

    it('login', function(done) {
        utils.login('A',done);
    });

    describe("POST - create a new list", function() {
      it('with invalid fields', function(done) {
          utils.A.request.post('/api/list')
          .set('Content-Type', 'application/json')
          .end(function(err, res){
              if(err) throw err;
              res.status.should.equal(400);
              done();
          });
      });

      it('valid fields', function(done) {
          utils.A.request.post('/api/list')
          .set('Content-Type', 'application/json')
          .send({actor: "testActor", title: "testEvent", description: 'test description' })
          .end(function(err, res){
              if(err) throw err;
              res.status.should.equal(200);
              res.body.should.have.property('title').and.be.an('string');
              res.body.should.have.property('description').and.be.an('string');
              res.body.should.have.property('subscriptions').and.be.an('array');
              res.body.should.have.property('objectType').and.be.equal('list');
              object_id = res.body.id;
              done();
          });
      });
    });

    describe("GET - retrieve lists", function() {

      it('retreive a list', function(done) {
          utils.A.request.get('/api/list/' + object_id)
          .set('Content-Type', 'application/json')
          .end(function(err, res){
              if(err) throw err;
              res.status.should.equal(200);
              res.body.should.have.property('title').and.be.an('string');
              done();
          });
      });
    });

    describe("PUT - modify a list", function() {

      it('shouldnt be modfied by another user', function(done) {
          utils.B.request.put('/api/list/' + object_id)
          .set('Content-Type', 'application/json')
          .send({title: "testCollectionModified" })
          .end(function(err, res){
              res.status.should.equal(403);
              done();
          });
      });

      it('modify an collection', function(done) {
          utils.A.request.put('/api/list/' + object_id)
          .set('Content-Type', 'application/json')
          .send({title: "testCollectionModified" })
          .end(function(err, res){
              if(err) throw err;
              res.status.should.equal(200);
              res.body.should.have.property('title').and.be.equal('testCollectionModified');
              done();
          });
      });
    });

    describe("DELETE - delete a list", function() {

      it('it shouldnt be modfied by another user', function(done) {
          utils.B.request.del('/api/list/' + object_id)
          .end(function(err, res){
              if(err) throw err;
              res.status.should.equal(403);
              done();
          });
      });

      it('delete an collection', function(done) {
          utils.A.request.del('/api/list/' + object_id)
          .end(function(err, res){
              if(err) throw err;
              res.status.should.equal(200);
              done();
          });
      });
    });
});
