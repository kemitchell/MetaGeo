var config = require("../config"),
    sock = null,
    sessionId = null,
    sockB = null,
    sessionIdB = null,
    SockJS = require('sockjs-client-node'),
    utils = require('../utils'),
    should = require('chai').should(),
    options = {
        transports: ['websocket'],
        'force new connection': true
    };

describe('Sockets', function() {
    before(function(done) {
        utils.login('A', done);
    });

    it("should connect", function(done) {
        sock = new SockJS(config.test.url + "/stream");
        sock.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.connack.should.have.property('sessionId');
            sessionId = data.connack.sessionId;
            done();
        };
    });

    it("should connect again", function(done) {
        sockB = new SockJS(config.test.url + "/stream");
        sockB.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.connack.should.have.property('sessionId');
            sessionIdB = data.connack.sessionId;
            done();
        };
    });

    it("should subscribe through the REST API", function(done) {
        sock.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.should.have.property('suback');
            done();
        };
        utils.A.request.get('/api/events/?sub='+sessionId).end(function(err, res) {});
    });

    it("should broadcast new events to everyone ever", function(done) {
        var count = 0;
        var numOfEvents = 5;
        sock.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.publish.action.should.equal('create');
            if (count === numOfEvents) {
                done();
            }
            count++;
        };
        utils.createRandomEvents('A', 5, config.A.bounds);
    });

    it("should broadcast updated events", function(done) {
        sock.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.publish.action.should.equal('update');
            done();
        };
        utils.updateEvent('A');
    });

    it.skip("should broadcast deleted events", function(done) {
        sock.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.publish.action.should.equal('delete');
            done();
        };
        utils.deleteEvent('A');
    });

    it('subscribe to events inside a bounds A', function(done) {
        var bounds = config.A.bounds;
        bounds = bounds[0][0] + "," + bounds[0][1] + "," + bounds[1][0] + "," + bounds[1][1];

        sock.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.should.have.property('suback');
            done();
        };

        utils.A.request.get('/api/events/?box='+bounds + '&sub=' + sessionId)
            .set('Content-Type', 'application/json')
            .end(function(err, res) {
            res.status.should.equal(200);
            res.body.items.should.be.an("array");
        });
    });

    it('subscription should only get events inside the subscribed bounds', function(done){
        sock.onmessage = function(message) {
            var data = JSON.parse(message.data);
            data.publish.action.should.equal('create');
            data.publish.model.actor.should.equal(config.B.user.username);
            //delete sock.onmessage;
            done();
        };

        utils.createRandomEvents('A', 4, config.B.bounds, function(){
            utils.createRandomEvents('B', 0, config.A.bounds, function(){
            });
        });

    });

});
