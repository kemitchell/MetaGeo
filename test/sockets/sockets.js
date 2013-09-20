var server = require('../../server'),
SockJS = require('sockjs-client-node'),
socketURL = 'http://0.0.0.0:1337/echo';
options ={
    transports: ['websocket'],
    'force new connection': true
};

describe('Sockets', function() {
    it("should connect", function(done){
      sock =  new SockJS(socketURL);
      sock.onopen = function() {
        done();
      };
    });

    it("should broadcast new events to everyone ever", function(done){
      done()
    });
});
