var server = require('../server'),
config = {
  server: {
    port: 1338 
  } 
  
}


before(function(done) {
    server.start(done);
});

after(function(done) {
    server.stop({timeout:200},done);
});
