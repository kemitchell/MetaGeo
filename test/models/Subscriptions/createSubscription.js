// NOTE: TEST INCOMPLETE, DO NOT RELY ON THIS

require('coffee-script')
var should = require('chai').should();
var mongoConf = require('../../config').mongo;
var Collection = require('../../../models/list');
var User = require('../../../models/user');
var Subscription = require('../../../models/subscription');
var async = require('async');
var mongoose = require('mongoose');

var user1 = new User({
    "title":"my collection",
    "email":"test1@test.com",
    "password":"testpass",
    "slug":"test1"
});
var user2 = new User({
    "title":"my collection",
    "email":"test2@test.com",
    "password":"testpass",
    "slug":"test2"
});
var user3 = new User({
    "title":"my collection",
    "email":"test3@test.com",
    "password":"testpass",
    "slug":"test3"
});
var collection1 = new Collection({
    "title":"testCollection1",
    "slug":"testCol1"
});
var collection2 = new Collection({
    "title":"testCollection2",
    "slug":"testCol2"
});
var collection3 = new Collection({
    "title":"testCollection3",
    "slug":"testCol3"
});

var createFixtures = function(cb){
    async.series([function(callback){
        user1.save(function(err){
            if (err) return callback(err);
            callback(null,user1);
        })
    },function(callback){
        user2.save(function(err){
            if (err) return callback(err);
            callback(null,user2);
        })
    },function(callback){
        user3.save(function(err){
            if (err) return callback(err);
            callback(null,user3);
        })
    },function(callback){
        collection1.save(function(err){
            if (err) return callback(err);
            callback(null,collection1);
        })
    },function(callback){
        collection2.save(function(err){
            if (err) return callback(err);
            callback(null,collection2);
        })
    },function(callback){
        collection3.save(function(err){
            if (err) return callback(err);
            callback(null,collection3);
        })
    }],function(err,results){
        cb(err);
    });
}

describe.skip('Create Collection',function(){
    before(function(done){
        this.timeout(5000);
        require('../../../db').start(mongoConf,function(){
            createFixtures(done);
        });
    });

    it('should not create a collection if there is no title',function(done){
        var collection = new Collection({});
        collection.save(function(err){
            should.exist(err)
            done();
        });
    });
    
    it('should create a collection if there is a title',function(done){
        var collection = new Collection({
            title:"test title"
        });
        collection.save(function(err){
            should.not.exist(err)
            done();
        });
    });

    after(function(done){
        mongoose.connection.collections['aggregate'].drop(function(err){
            require('../../../db').stop(done);
        });
    });
});
