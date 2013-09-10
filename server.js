#!/bin/env node

require('coffee-script');
require('./connection');

var Hapi = require('hapi');
var SocketIO = require('socket.io');
var routes = require('./routes');

var config = { };
var server = new Hapi.Server('0.0.0.0', 1337, config);

server.auth('session', {
    scheme: 'cookie',
    password: 'secret sauce',
    cookie: 'sid-em',
    isSecure: false
});

server.pack.require({ lout: { endpoint: '/docs' } }, function (err) {

    if (err) {
        console.log('Failed loading plugins');
    }
});

server.addRoutes(routes);

server.start(function () {
  var io = SocketIO.listen(server.listener);
});
