var metageo = require('../index'),
    testConfig = require('./config'),
    config = require('../config/default'),
    utils = require('./utils'),
    _ = require('lodash'),
    mongoose = require('mongoose');

before(function(done) {
    _.merge(config, testConfig);
    metageo.start(config, function(){
      utils.createUser(done);
    });
});

after(function(done) {
    //clear the db
    if (!config.dontDelete) {
        metageo.server.plugins['metageo-core'].mongoose.connection.db.dropDatabase(
          metageo.server.stop({
              timeout: 200
          }, done));
    } else {
        done();
    }
});
