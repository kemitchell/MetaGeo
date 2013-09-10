var should = require('chai').should(),
  supertest = require('supertest'),
  api = supertest('http://localhost:1337');

describe('/collection', function() {
    var object_id = null;  

    it('GET: collection', function(done) {
        api.get('/collection')
        .set('Content-Type', 'application/json')
        .expect(200)
        .end(function(err, res){
            if(err) throw err;
            res.body.should.be.an('array');
            done();            
        });
    });

    it('create a new collection with invalid fields', function(done) {
        api.post('/collection')
        .set('Content-Type', 'application/json')
        .expect(400)
        .end(function(err, res){
            if(err) throw err;
            done();
        });
    });

    it('create a new collection valid fields', function(done) {
        api.post('/collection')
        .set('Content-Type', 'application/json')
        .send({actor: "testActor", title: "testEvent" })
        .expect(200)
        .end(function(err, res){
            if(err) throw err;
            res.body.should.have.property('title').and.be.an('string');
            object_id = res.body.id;
            done();
        });
    });

    it('retreive a collection', function(done) {
        api.get('/collection/' + object_id)
        .set('Content-Type', 'application/json')
        .expect(200)
        .end(function(err, res){
            if(err) throw err;
            res.body.should.have.property('title').and.be.an('string');
            done();
        });
    });

    it('modify an collection', function(done) {
        api.put('/collection/' + object_id)
        .set('Content-Type', 'application/json')
        .send({actor: "testActorModified", title: "testCollectionModified" })
        .expect(200)
        .end(function(err, res){
            if(err) throw err;
            res.body.should.have.property('title').and.be.an('string');
            done();
        });
    });

    it('delete an collection', function(done) {
        api.del('/collection/' + object_id)
        .expect(200)
        .end(function(err, res){
            if(err) throw err;
            done();
        });
    });
});
