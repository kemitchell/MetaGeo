var server = require('../server');

describe('Server', function() {

    it('should start', function(done) {
      server.start(done);
    });

    it('should stop', function(done){
      server.stop(done);
    })

});
