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
    async   = require('async'),
    qs      = require('qs'),
    routes  = require('./routes'),
    db      = require('./db'),
    Bcrypt = require('bcrypt');
    server  = null,
    config  = null,

/**
 * Starts the http server, sock server and connects to the DB
 * @method start
 * @param {Object} options An options hash that will be merged with the config file
 * @cb {Function} cb A callback for when everything is up and running
 **/
metageo.start = function(config, cb) {

    server = new Hapi.Server(config.server.host, Number(config.server.port), {app:config.app});

    //setup the API server
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

    async.parallel([
        //start the db
        function(callback){
            db.start(config.db, callback);
        },
        function(callback){
            server.pack.require('hapi-auth-cookie', function (err) {
                server.auth.strategy('session', 'cookie', config.auth.cookie);
                server.route(routes);
                callback();
            });
        },
        function(callback){
            server.pack.require(config.plugins, callback);
        },
        function(callback){
            server.start(callback);
        }
    ],cb);
};

/**
 * Stops everything ever
 * @method stop
 * @param {Object} an option hash that get passed to hapi.stop
 * @param {Function} a callback function
 **/
metageo.stop = function(options, cb) {
    var options;
    if (_.isFunction(options) && _.isUndefined(cb)) {
        cb = options;
        options = config.server.stop;
    }

    async.parallel([
        function(cb){
            server.stop(options, cb);
        },
        db.stop
    ], cb);
};

//if runing the app directly start the server else just export it
module.exports = metageo;
