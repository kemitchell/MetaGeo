#!/bin/env node

             require('coffee-script');
var Hapi =   require('hapi'),
_ =          require('lodash'),
qs =         require('qs'),
routes =     require('./routes'),
config =     require('./config'),
db =         require('./db'),
sockets =    require('./socket'),
eventmap =   {},
server =     null;

eventmap.start = function(options, cb){

  var options; 
  if( _.isFunction(options) && _.isUndefined(cb)){
    cb = options;
  }else{
    _.extend(config, options)
  }

  //fire up the database
  db.start(config.mongo);
  //setup the API server
  server = new Hapi.Server(config.server.host, Number(config.server.port), config.server.options);
  //set authentication
  server.auth(config.authentication.name, config.authentication.options);
  //add some plugins
  server.pack.require({ lout: { endpoint: '/docs' } }, function (err) {
    if (err) {
      console.log('Failed loading plugins');
    }
  });
  //add routes
  server.addRoutes(routes);

  server.ext('onRequest', function (request, next) {
    //add nested query strings
    if(request.method == "get" && request.url.pathname != '/docs'){ 
      request.query = qs.parse(request.url.search.slice(1))
    }

    next();
  });

  //start the server
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
    options = config.server.stop;
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
