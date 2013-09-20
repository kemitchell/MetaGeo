var server = require('../server');

before(function(done) {
    server.start(done);
});

after(function(done) {
    server.stop({timeout:200},done);
});
