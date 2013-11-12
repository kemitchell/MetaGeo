var config = require("../config"),
    sock = null,
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
        sock.onopen = function() {
            done();
        };
    });

    it("should broadcast new events to everyone ever", function(done) {
        var count = 0;
        var numOfEvents = 5;
        sock.onmessage = function(message) {
            data = JSON.parse(message.data);
            data.action.should.equal('create');
            if (count === numOfEvents) {
                done();
            }
            count++;
        };
        utils.createRandomEvents('A', 5, config.A.bounds);
    });

    it("should broadcast updated events", function(done) {
        sock.onmessage = function(message) {
            data = JSON.parse(message.data);
            data.action.should.equal('update');
            done();
        };
        utils.updateEvent('A');
    });

    it("should broadcast deleted events", function(done) {
        sock.onmessage = function(message) {
            data = JSON.parse(message.data);
            data.action.should.equal('delete');
            done();
        };
        utils.deleteEvent('A');
    });
});
