var config = require("../config"),
    supertest = require('supertest'),
    async = require("async"),
    request = supertest.agent(config.url);

module.exports = {
    userId: null,
    request: request,

    logout: function(cb) {
        console.log("logout")
        this.request.del('/login')
            .end(function(err, res) {
            cb();
        });
    },
    login: function(cb) {
        var self = this;
        this.request.post('/login')
            .set('Content-Type', 'application/json')
            .send({
            username: config.username,
            password: config.password
        })
        .end(function(err, res) {
            if (res) {
                self.userId = res.body.id;
            }
            cb();
        });
    },
    createUser: function(cb) {
        var self = this;
        this.request.post('/user')
            .set('Content-Type', 'application/json')
            .send({
            username: config.username,
            password: config.password
        })
            .end(function(err, res) {
            if (res) {
                self.userId = res.body.id;
            }
            cb();
        });
    },
    createRandomEvents: function(num, bounds, cb) {
        var count = 0;
        request = this.request;
        that = this
        async.series([
            function(callback){
                that.login.bind(that)(callback);
            },
            function(callback){
              async.whilst(
                function(){ 
                    return count < num;
                },
                function(callback){
                  count++;
                  var y = Math.random() * (bounds[0][0] - bounds[1][0]) + bounds[1][0];
                  var x = Math.random() * (bounds[0][1] - bounds[1][1]) + bounds[1][1];
                  request.post('/event/social')
                      .set('Content-Type', 'application/json')
                      .send({
                          title: "test_" + count,
                          content: "testContent",
                          start: new Date(),
                          lat: x,
                          lng: y
                      })
                      .end(function(err, res){
                          if(err){
                            console.error("creating events broke", err);
                            console.log(res.body);
                          }
                          callback();
                      });
                },
                function(err){
                  callback();
                });
            }
        ],
        function(err, results){
            console.log("end")
            cb();
        }
      );
    }
}
