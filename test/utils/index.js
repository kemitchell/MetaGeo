var config = require("../config"),
    supertest = require('supertest'),
    async = require("async"),
    request = supertest.agent(config.test.url);

module.exports = {
    userId: null,
    request: request,
    randomDate: function(start, end) {
      return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()))
    },
    logout: function(cb) {
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
            username: config.test.username,
            password: config.test.password
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
            username: config.test.username,
            password: config.test.password,
            email: config.test.email
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
        _this = this
        async.series([
            function(callback){
                _this.login.bind(_this)(callback);
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
                  start = _this.randomDate(new Date(), new Date(2099,0,1)),
                  end =  _this.randomDate(start, new Date(2099,0,1));
                  request.post('/event/social')
                      .set('Content-Type', 'application/json')
                      .send({
                          title: "test_" + count,
                          content: "testContent",
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
}
