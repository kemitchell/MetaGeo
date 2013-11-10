var should = require('chai').should(),
    assert = require('chai').assert,
    config = require("../config"),
    utils = require('../utils');

describe('/api/events/', function() {
    var numOfEvents = 30;
    before(function(done) {
        utils.createRandomEvents('A', numOfEvents, config.A.bounds, done);
    });

    it('get a list of events', function(done) {
        utils.A.request.get('/api/events/')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(numOfEvents);
            done();
        });
    });

    it('get events inside a bounds A', function(done) {
        var bounds = config.A.bounds;
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1];
        utils.A.request.get('/api/events/?box='+bounds)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(numOfEvents);
            done();
        });
    });

    it('get events inside a bounds B', function(done) {
        var bounds = config.B.bounds;
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1];
        utils.A.request.get('/api/events/?box='+bounds)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(0);
            done();
        });
    });

    it('get events inside a with title of test_2', function(done) {
        utils.A.request.get('/api/events/?title=test_2')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(1);
            done();
        });
    });

    it('should sort event by start', function(done) {
        utils.A.request.get('/api/events/').set('Content-Type', 'application/json').end(function(err, res) {
              prevItem = false;
              _this = this;
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  if(_this.prevItem){
                    assert(_this.prevItem.start <= item.start, 'items not in oder');
                  }
                  _this.prevItem = item;
              });
              done();
        });
    });

    it('should sort event by title', function(done) {
        utils.A.request.get('/api/events/?sort=title').set('Content-Type', 'application/json').end(function(err, res) {
              prevItem = false;
              _this = this;
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  if(_this.prevItem){
                    assert(_this.prevItem.title <= item.title, 'items not in oder');
                  }
                  _this.prevItem = item;
              });
              done();
        });
    });

    it('should sort event by title descending', function(done) {
        utils.A.request.get('/api/events/?sort=-title').set('Content-Type', 'application/json').end(function(err, res) {
              prevItem = false;
              _this = this;
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  if(_this.prevItem){
                    assert(_this.prevItem.title >= item.title, 'items not in oder');
                  }
                  _this.prevItem = item;
              });
              done();
        });
    });

    it('should return events great than', function(done) {
        date = utils.randomDate(new Date(), new Date(2099,0,1));
        utils.A.request.get('/api/events/?start[gt]='+ date.toJSON()).set('Content-Type', 'application/json').end(function(err, res) {
              res.status.should.equal(200);
              res.body.items.should.be.an("array");
              res.body.items.forEach(function(item){
                  assert(item.start > date.toJSON() , 'items not in oder');
              });
              done();
        });
    });

    it('should return events less than', function(done) {
        var date = utils.randomDate(new Date(), new Date(2099,0,1));
        utils.A.request.get('/api/events/?start[lt]=' + date.toJSON())
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.forEach(function(item){
                assert(item.start < date.toJSON() , 'items not in oder');
            });
            done();
        });
    });

    it('should return events by user', function(done) {
        utils.A.request.get('/api/events/user/' + config.A.user.username + "/")
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(numOfEvents);
            done();
        });
    });

    it('should return mblog events', function(done) {
        utils.A.request.get('/api/events/mblog/')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(0);
            done();
        });
    });

    it('should return socail events', function(done) {
        utils.A.request.get('/api/events/social/')
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
            res.body.items.length.should.equal(numOfEvents)
            done();
        });
    });
});
