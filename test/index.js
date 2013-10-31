var server = require('../server'),
    config = require('./config'),
    utils = require('./utils'),
    mongoose = require('mongoose');

before(function(done) {
    server.start(config, utils.createUser(done));
});

after(function(done) {
    //clear the db
    if (!config.dontDelete) {
        mongoose.connection.db.dropDatabase();
        server.stop({
            timeout: 200
        }, done);
    } else {
        done();
    }
});
