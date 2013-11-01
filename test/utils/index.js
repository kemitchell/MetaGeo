var config = require("../config"),
    supertest = require('supertest'),
    async = require("async"),
    requestA = supertest.agent(config.test.url),
    requestB = supertest.agent(config.test.url);

module.exports = {
    A:{
        request: requestA,
        userId: null
    },
    B:{
        request: requestB,
        userId: null
    },
    randomDate: function(start, end) {
      return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
    },
    logout: function(cb) {
        var self = this;
        this.A.request.del('/login')
            .end(function(err, res) {
            self.B.request.del('/login')
                .end(function(err, res) {
                cb();
            });
        });
    },
    login: function(AB,cb) {
        var self = this;
        this[AB].request.post('/login')
            .set('Content-Type', 'application/json')
            .send({
            username: config[AB].user.username,
            password: config[AB].user.password
        })
        .end(function(err, res) {
            if (res) {
                self[AB].userId = res.body.id;
            }
            cb();
        });
    },
    createUser: function(cb) {
        var self = this;
        this.A.request.post('/user')
            .set('Content-Type', 'application/json')
            .send({
            username: config.A.user.username,
            password: config.A.user.password,
            email: config.A.user.email
        })
            .end(function(err, res) {
            if (res) {
                self.A.userId = res.body.id;
            }
            //create user B
            self.B.request.post('/user')
                .set('Content-Type', 'application/json')
                .send({
                username: config.B.user.username,
                password: config.B.user.password,
                email: config.B.user.email
            })
                .end(function(err, res) {
                if (res) {
                    self.B.userId = res.body.id;
                }
                cb();
            });
        });
    },
    createRandomEvents: function(AB, num, bounds, cb) {
        var count = 0,
        request = this[AB].request,
        self = this;

        async.series([
            function(callback){
                self.login.bind(self)([AB],callback);
            },
            function(callback){
              async.whilst(
                function(){ 
                    return count < num+1;
                },
                function(callback){
                  count++;
                  var y = Math.random() * (bounds[0][0] - bounds[1][0]) + bounds[1][0],
                  x = Math.random() * (bounds[0][1] - bounds[1][1]) + bounds[1][1],
                  start = self.randomDate(new Date(), new Date(2099,0,1)),
                  end = self.randomDate(start, new Date(2099,0,1));

                  request.post('/event/social')
                      .set('Content-Type', 'application/json')
                      .send({
                          title: "test_" + count,
                          content: "testContent" + count,
                          start: start,
                          end: end,
                          lat: x,
                          lng: y
                      })
                      .end(function(err, res){
                          if(err){
                            console.error("creating events broke", err);
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
            cb();
        }
      );
    }
};
