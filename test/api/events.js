var should = require('chai').should(),
  supertest = require('supertest'),
  api = supertest('http://localhost:1337');


describe('/events', function() {
    it('get a list of events', function(done) {
        api.get('/events')
        .set('Content-Type', 'application/json')
        .expect(200)
        .end(function(err, res){
            if(err) throw err;
            res.body.should.be.an("array");
            done();
        });
    });

});
