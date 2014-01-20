var server = require('../index'),
    testConfig = require('./config'),
    config = require('../config/default')
    utils = require('./utils'),
    _ = require('lodash'),
    mongoose = require('mongoose');

before(function(done) {
    _.merge(config, testConfig);
    server.start(config, utils.createUser(done));
});

after(function(done) {
    //clear the db
    if (!config.dontDelete) {
        mongoose.connection.db.dropDatabase(
          server.stop({
              timeout: 200
          }, done));
    } else {
        done();
    }
});
