var server = require('../../server'),
config = require("../config"),
SockJS = require('sockjs-client-node'),
options ={
    transports: ['websocket'],
    'force new connection': true
};

describe('Sockets', function() {
    it("should connect", function(done){
      sock =  new SockJS(config.test.url + "/echo");
      sock.onopen = function() {
        done();
      };
    });

    it("should broadcast new events to everyone ever", function(done){
      done()
    });
});
