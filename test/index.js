var server = require('../server'),
config  = require('./config')

before(function(done) {
    server.start(config, done);
});

after(function(done) {
    server.stop({timeout:200}, done);
});
