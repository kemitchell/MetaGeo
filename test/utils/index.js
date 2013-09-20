var config = require("../config"),
supertest = require('supertest'),
request = supertest.agent(config.url);

module.exports = {
    userId: null,
    request: request,
    login: function(cb){
        var self = this;
        this.request.post('/login')
        .set('Content-Type', 'application/json')
        .send({username: config.username, password: config.password })
        .end(function(err, res){
            if(res){
              self.userId = res.body.id;
            }
            cb();
        });
    },
    createUser: function(cb){
        var self = this;
        this.request.post('/user')
        .set('Content-Type', 'application/json')
        .send({username: config.username, password: config.password })
        .end(function(err, res){
            if(res){
              self.userId = res.body.id;
            }
            cb();
        });
    },
    destroyUser: function(cb){
        this.request.del('/user/' + this.object_id)
        .end(function(err, res){
            cb();
        });
    }
}
