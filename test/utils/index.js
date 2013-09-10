var request = require("superagent"),
url = 'http://localhost:1337';

module.exports = {

    cookie: null,
    object_id: null,

    login: function(testUser, password, cb){
        var self = this;
        request.post(url + '/login')
        .set('Content-Type', 'application/json')
        .send({username: testUser, password: password })
        .end(function(err, res){
            self.object_id = res.body.id;
            cb();
        });
    },

    createUser: function(testUser, password, cb){
        var self = this;
        request.post(url + '/user')
        .set('Content-Type', 'application/json')
        .send({username: testUser, password: password })
        .end(function(err, res){
            if( res.error){
              self.login(testUser, password, cb);
            }else{

              self.object_id = res.body.id;
              cb();
            }
        });
     },

    destroyUser: function(cb){
        var self = this;
        request.del(url + '/user/' + self.object_id)
       .end(function(err, res){
            cb();
        });
    }
}
