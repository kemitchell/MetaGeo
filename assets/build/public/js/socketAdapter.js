(function() {
  define(function(require) {
    var Backbones, io, socket;
    Backbones = require('backbone');
    io = require('socket.io-client');
    require('js/sails.io.js');
    socket = io.connect("?bounds=[-90,90]");
    window.socket = socket;
    return socket.on('connect', function() {
      return socket.on('message', function(message) {
        if (message.model === 'event' && message.verb === 'create') {
          return window.vent.trigger('eventAdd', message.data);
        }
      });
    });
  });

}).call(this);
