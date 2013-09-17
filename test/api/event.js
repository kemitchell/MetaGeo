var should = require('chai').should(),
  supertest = require('supertest'),
  api = supertest.agent('http://localhost:1337'),
  testUser = "testUser20",
  password = "password",
  user_id;

before(function(done){
    self = this;
    api.post('/user')
    .set('Content-Type', 'application/json')
    .send({username: testUser, password: password })
    .end(function(err, res){
        self.user_id = res.body.id;
        api.post('/login')
        .set('Content-Type', 'application/json')
        .send({username: testUser, password:password })
        .end(function(err, res){
            done();
        });
    });


});


after(function(done){
    api.del('/user/' + this.user_id)
   .end(function(err, res){
        done();
    });
});

describe('/event', function() {
    var event_id = null;  

    describe("POST - create a new event", function(){

        it('create a new event with invalid fields', function(done) {
            api.post('/event')
            .expect(400, done)
        });

        it('create a new event valid fields', function(done) {
            api.post('/event')
            .set('Content-Type', 'application/json')
            .send({ 
                title: "testEvent3", 
                content: "testContent", 
                time: new Date(),
                lat: 34,
                lng: -90
            })
            .expect(200)
            .end(function(err, res){
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('title').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                event_id = res.body.id;
                done();
            });
        });
    });

    describe("GET - retrieve an event", function(){
        it('get with out an ID', function(done) {
            api.get('/event')
            .set('Content-Type', 'application/json')
            .expect(200)
            .end(function(err, res){
                res.body.should.have.property('items').and.be.an('array');
                done();            
            });
        });

        it('retreive an event', function(done) {
            api.get('/event/' + event_id)
            .set('Content-Type', 'application/json')
            .expect(200)
            .end(function(err, res){
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('title').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                done();
            });
        });
    });

    describe("PUT - modiy an event", function(){
        it('modify an event', function(done) {
            api.put('/event/' + event_id)
            .set('Content-Type', 'application/json')
            .send({title: "testEventModified", "time": new Date(), content: "testContentModified" })
            .expect(200)
            .end(function(err, res){
                res.body.should.have.property('actor').and.be.an('string');
                res.body.should.have.property('title').and.be.an('string');
                res.body.should.have.property('content').and.be.an('string');
                done();
            });
        });
    });

    describe("DELETE - delete an event", function(){
        it('delete an event', function(done) {
            api.del('/event/' + event_id)
            .expect(200, done)
        });
    });

});
