(function() {
  define(function(require) {
    var sock, sockjs_url;
    require('socketjs-client');
    sockjs_url = '/echo';
    sock = new SockJS(sockjs_url);
    sock.onopen = function() {
      return console.log('open');
    };
    sock.onmessage = function(e) {
      return console.log('message', e.data);
    };
    return sock.onclose = function() {
      return console.log('close');
    };
  });

}).call(this);
