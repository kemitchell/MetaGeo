#!/bin/env node
/**
 * MetaGeo. A geospatial and temporial mapping and aggergation system
 * @module metageo
 **/

//in the begining a varible was declared and there was a varible. The Programmer saw that the varible was good.
var metageo = {},
    cs      = require('coffee-script'),
    Hapi    = require('hapi'),
    _       = require('lodash'),
    qs      = require('qs'),
    routes  = require('./routes'),
    config  = require('./config'),
    db      = require('./db'),
    sockets = require('./socket'),
    server  = null;

/**
 * Starts the http server, sock server and connects to the DB
 * @method start
 * @param {Object} options An options hash that will be merged with the config file
 * @cb {Function} cb A callback for when everything is up and running
 **/
metageo.start = function(options, cb) {

    if (_.isFunction(options) && _.isUndefined(cb)) {
        cb = options;
    } else {
        //merge the passed in options with the config file
        _.merge(config, options);
    }

    //fire up the database
    db.start(config.mongo);
    //setup the API server
    server = new Hapi.Server(config.server.host, Number(config.server.port), config.server.options);
    //set authentication
    server.auth(config.server.authentication.name, config.server.authentication.options);

    //add routes
    server.addRoutes(routes);

    server.ext('onRequest', function(request, next) {
        //add nested query strings
        if (request.method == "get") {
            request.query = qs.parse(request.url.search.slice(1));
        }
        next();
    });

    server.ext('onPreResponse', function(request, next) {
        var response = request.response();
        if (response.isBoom) {
            if (response.code === 500) {
                //log internal errors
                server.log(['error'], response.message);
            } else {
                //use unflattened message
                response.response.payload.message = response.message;
            }
        }
        return next(response);
    });

    //write errors to console
    server.on('log', function(event, tags) {
        if (tags.error) {
            console.log(event);
        }
    });

    //start the server
    server.start(function() {
        //start sockets
        sockets.start(server.listener, config.sockjs);
        if (_.isFunction(cb)) {
            cb();
        }
    });
};

/**
 * Stops everything ever
 * @method stop
 * @param {Object}
 * @param.timeout {Time} Passed to hapi.stop
 *
 **/
metageo.stop = function(options, cb) {
    var options;
    if (_.isFunction(options) && _.isUndefined(cb)) {
        cb = options;
        options = config.server.stop;
    }

    server.stop(options, function() {
        db.stop();
        console.log('Server stopped');
        if (_.isFunction(cb)) {
            cb();
        }
    });
}

//if runing the app directly start the server else just export it
if (require.main === module) {
    metageo.start();
} else {
    module.exports = metageo;
}
