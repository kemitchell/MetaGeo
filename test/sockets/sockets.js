var config = require("../config"),
    WebSocket = require('ws'),
    a = {
      ws: null,
      sessionId: null
    },
    b = {
      ws: null,
      sessionId: null
    },
    utils = require('../utils'),
    should = require('chai').should();

describe('WebSockets', function() {
    before(function(done) {
        utils.login('A', done);
    });

    it("should connect and acknowlge the connection with an ID", function(done) {
        a.ws = new WebSocket(config.test.url + '/pubsub/ws');
        a.ws.on('open', function(data) {
            a.ws.onmessage = function(message){
                data = JSON.parse(message.data);
                data.connack.should.have.property('sessionId');
                a.sessionId = data.connack.sessionId;
                done();
            };
        });
    });

    it("should connect again", function(done) {
        b.ws = new WebSocket(config.test.url + '/pubsub/ws');
        b.ws.on('open', function(data) {
            b.ws.onmessage = function(message){
                data = JSON.parse(message.data);
                data.connack.should.have.property('sessionId');
                b.sessionId = data.connack.sessionId;
                done();
            };
        });
    });

    it("should subscribe through the REST API", function(done) {
        a.ws.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.should.have.property('suback');
            done();
        };
        utils.A.request.get('/api/events/?client='+a.sessionId).end(function(err, res) {});
    });

    it("should broadcast new events to everyone ever", function(done) {
        var count = 0;
        var numOfEvents = 5;
        a.ws.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.pub.action.should.equal('create');
            if (count === numOfEvents) {
                done();
            }
            count++;
        };
        utils.createRandomEvents('A', 5, config.A.bounds);
    });

    it("should broadcast updated events", function(done) {
        a.ws.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.pub.action.should.equal('update');
            done();
        };
        utils.updateEvent('A');
    });

    it("should broadcast deleted events", function(done) {
        a.ws.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.pub.action.should.equal('delete');
            a.ws.onmessage = null;
            done();
        };
        utils.deleteEvent('A');
    });

    it('subscribe to events inside a bounds A', function(done) {
        var bounds = config.A.bounds;
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1];

        b.ws.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.should.have.property('suback');
            done();
        };

        utils.A.request.get('/api/events/?box=' + bounds + '&client=' + b.sessionId)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
        });
    });

    it('subscription should only get events inside the subscribed bounds', function(done){
        b.ws.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.pub.action.should.equal('create');
            data.pub.model.actor.should.equal(config.B.user.username);
            done();
        };

        utils.createRandomEvents('A', 4, config.B.bounds, function(){
            utils.createRandomEvents('B', 1, config.A.bounds, function(){
            });
        });

    });

});
