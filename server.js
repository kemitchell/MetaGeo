#!/bin/env node

require('coffee-script');

var Hapi = require('hapi');
routes = require('./routes'),
_ = require('lodash'),
db = require('./db'),
sockets = require('./socket'),
config = {},
eventmap = {},
server =  null;

eventmap.start = function(cb){
  
  //fire up the database
  db.start();

  server = new Hapi.Server('0.0.0.0', 1337, config);

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
    //start sockets
    sockets.start(server.listener);
    if(_.isFunction(cb)){
      cb();
    }
  });
}

eventmap.stop = function(options, cb){
  var options; 
  if( _.isFunction(options) && _.isUndefined(cb)){
    cb = options;
    options = { timeout: 60 * 1000 };
  }
  server.stop(options, function () {
    db.stop();
    console.log('Server stopped');
    if(_.isFunction(cb)){
      cb();
    }
  });
}

if(require.main === module){
  eventmap.start();
}else{
  module.exports = eventmap;
}
