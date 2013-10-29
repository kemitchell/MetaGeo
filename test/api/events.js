var should = require('chai').should(),
    assert = require('chai').assert,
    config = require("../config"),
    utils = require('../utils');

describe('/events/', function() {
    var numOfEvents = 30
    before(function(done) {
        utils.createRandomEvents(numOfEvents, config.test.boundsA, done)
        //utils.createRandomEvents(200, config.test.bounds2)
    });

    it('get a list of events', function(done) {
        utils.request.get('/events/')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(numOfEvents)
            done();
        });
    });

    it('get events inside a bounds A', function(done) {
        var bounds = config.test.boundsA
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1]
        utils.request.get('/events/?box='+bounds)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(numOfEvents)
            done();
        });
    });

    it('get events inside a bounds B', function(done) {
        var bounds = config.test.boundsB
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1]
        utils.request.get('/events/?box='+bounds)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(0)
            done();
        });
    });

    it('get events inside a with title of test_2', function(done) {
        utils.request.get('/events/?title=test_2')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(1)
            done();
        });
    });

    it('should sort event by start', function(done) {
        utils.request.get('/events/').set('Content-Type', 'application/json').end(function(err, res) {
              prevItem = false;
              _this = this;
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  if(_this.prevItem){
                    assert(_this.prevItem.start < item.start, 'items not in oder')
                  }
                  _this.prevItem = item
              });
              done();
        });
    });

    it('should sort event by title', function(done) {
        utils.request.get('/events/?sort=title').set('Content-Type', 'application/json').end(function(err, res) {
              prevItem = false;
              _this = this;
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  if(_this.prevItem){
                    assert(_this.prevItem.title < item.title, 'items not in oder')
                  }
                  _this.prevItem = item
              });
              done();
        });
    });

    it('should sort event by title descending', function(done) {
        utils.request.get('/events/?sort=-title').set('Content-Type', 'application/json').end(function(err, res) {
              prevItem = false;
              _this = this;
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  if(_this.prevItem){
                    assert(_this.prevItem.title > item.title, 'items not in oder')
                  }
                  _this.prevItem = item
              });
              done();
        });
    });

    it('should return events great than', function(done) {
        date = utils.randomDate(new Date(), new Date(2099,0,1));
        utils.request.get('/events/?start[gt]='+ date.toJSON()).set('Content-Type', 'application/json').end(function(err, res) {
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  assert(item.start > date.toJSON() , 'items not in oder')
              });
              done();
        });
    });

    it('should return events less than', function(done) {
        date = utils.randomDate(new Date(), new Date(2099,0,1))
        utils.request.get('/events/?start[lt]=' + date.toJSON())
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.forEach(function(item){
                assert(item.start < date.toJSON() , 'items not in oder')
            });
            done();
        });
    });

    it('should return events by user', function(done) {
        date = utils.randomDate(new Date(), new Date(2099,0,1))
        utils.request.get('/events/user/' + config.test.username + "/")
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(numOfEvents)
            done();
        });
    });
});
