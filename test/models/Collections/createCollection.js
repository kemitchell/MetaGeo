// NOTE: TEST INCOMPLETE. DO NOT RELY ON THIS

require('coffee-script')
var mongoConf = require('../../config').mongo;
var should = require('chai').should();
var Collection = require('../../../models/collection');
var mongoose = require('mongoose');

describe.skip('Create Collection',function(){
    before(function(done){
        require('../../../db').start(mongoConf,done);
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
