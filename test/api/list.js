var should = require('chai').should(),
    utils = require('../utils'),
    object_id = null;

describe('/list', function() {
    
    after(function(done){
        utils.logout(done);
    });

    it('login', function(done) {
        utils.login('A',done);
    });

    describe("POST - create a new list", function() {
      it('with invalid fields', function(done) {
          utils.A.request.post('/list')
          .set('Content-Type', 'application/json')
          .expect(400)
          .end(function(err, res){
              if(err) throw err;
              done();
          });
      });

      it('valid fields', function(done) {
          utils.A.request.post('/list')
          .set('Content-Type', 'application/json')
          .send({actor: "testActor", title: "testEvent", description: 'test description' })
          .expect(200)
          .end(function(err, res){
              if(err) throw err;
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
          utils.A.request.get('/list/' + object_id)
          .set('Content-Type', 'application/json')
          .expect(200)
          .end(function(err, res){
              if(err) throw err;
              res.body.should.have.property('title').and.be.an('string');
              done();
          });
      });
    });

    describe("PUT - modify a list", function() {
      it('modify an collection', function(done) {
          utils.A.request.put('/list/' + object_id)
          .set('Content-Type', 'application/json')
          .send({title: "testCollectionModified" })
          .expect(200)
          .end(function(err, res){
              if(err) throw err;
              res.body.should.have.property('title').and.be.equal('testCollectionModified');
              done();
          });
      });
    });

    describe("DELETE - delete a list", function() {
      it('delete an collection', function(done) {
          utils.A.request.del('/list/' + object_id)
          .expect(200)
          .end(function(err, res){
              if(err) throw err;
              done();
          });
      });
    });
});
