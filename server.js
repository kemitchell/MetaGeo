#!/bin/env node
/**
 * EventMap. A geospatial and temporial mapping and aggergation system
 * @module eventmap
**/

//in the begining a varible was declared and there was a varible. The Programmer saw that the varible was good.
var eventmap =   {},
cs =         require('coffee-script'),
Hapi =       require('hapi'),
_ =          require('lodash'),
qs =         require('qs'),
routes =     require('./routes'),
config =     require('./config'),
db =         require('./db'),
sockets =    require('./socket'),
server =     null;

eventmap.start = function(options, cb){

  var options; 
  if( _.isFunction(options) && _.isUndefined(cb)){
    cb = options;
  }else{
    _.merge(config, options);
  }

  //fire up the database
  db.start(config.mongo);
  //setup the API server
  server = new Hapi.Server(config.server.host, Number(config.server.port), config.server.options);
  //set authentication
  server.auth(config.authentication.name, config.authentication.options);

  //add routes
  server.addRoutes(routes);

  server.ext('onRequest', function (request, next) {
    //add nested query strings
    if(request.method == "get"){
      request.query = qs.parse(request.url.search.slice(1));
    }
    next();
  });

  //log error
  server.ext('onPreResponse', function (request, next) {
    var response = request.response();
    //log internal errors
    if (response.isBoom && response.code === 500) {
      server.log(['error'], response.message);
    }
    return next();
  });

  //write errors to console
  server.on('log', function (event, tags) {
    if (tags.error) {
      console.log(event);
    }
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
//if runing the app direcly start the server else just export it
if(require.main === module){
  eventmap.start();
}else{
  module.exports = eventmap;
}
