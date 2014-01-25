/**
 * MetaGeo. A geospatial and temporial mapping and aggergation system
 * @module metageo
 **/

//in the begining a varible was declared and there was a varible. The Programmer saw that the varible was good.
var metageo = {},
    fs      = require('fs');
    cs      = require('coffee-script'),
    Hapi    = require('hapi'),
    _       = require('lodash'),
    qs      = require('qs'),
    routes  = require('./routes'),
    db      = require('./db'),
    authController = require('./controllers/authController'),
    server  = null,
    config  = null,
    Bcrypt = require('bcrypt');
;

/**
 * Starts the http server, sock server and connects to the DB
 * @method start
 * @param {Object} options An options hash that will be merged with the config file
 * @cb {Function} cb A callback for when everything is up and running
 **/
metageo.start = function(config, cb) {

    //fire up the database connection
    db.start(config.db);
    //setup the API server

    //serverOptions.app = config;
    server = new Hapi.Server(config.server.host, Number(config.server.port), {app:config.app});

    server.pack.require('hapi-auth-cookie', function (err) {
        server.auth.strategy('session', 'cookie', config.auth.cookie);
    })

    server.route(routes);
    server.ext('onPreResponse', function(request, next) {
        var response = request.response;
        if (response.isBoom) {
            if (response.code === 500) {
                //log internal errors
                server.log(['error'], response.message);
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
        console.log(config.plugins);
        server.pack.require(config.plugins, function(err){
            if(err){
              console.log(err);
            }
        });
    });
};

/**
 * Stops everything ever
 * @method stop
 * @param {Object}
 * @param.timeout {Time} Passed to hapi.stop
 **/
metageo.stop = function(options, cb) {
    var options;
    if (_.isFunction(options) && _.isUndefined(cb)) {
        cb = options;
        options = config.server.stop;
    }
    server.stop(options, function() {
        //shutdown subpub before shutting down the the DB, so it can clear the
        //subscription table
        server.plugins['metageo-pubsub'].stop();
        db.stop();
        if (_.isFunction(cb)) {
            cb();
        }
    });
};

//if runing the app directly start the server else just export it
module.exports = metageo;
