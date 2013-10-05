require('coffee-script')
var mongoConf = require('../../config').mongo;
var should = require('chai').should();
var User = require('../../../models/user');
var mongoose = require('mongoose');

describe.skip('Create User',function(){
    before(function(done){
        require('../../../db').start(mongoConf,done);
    });

    it('should not create a user if there is no email',function(done){
        var user = new User({
            password: "testCreateUser1",
            title: "My new collection",
            slug: "valid_url1"
        });
        user.save(function(err){
            should.exist(err)
            done();
        });
    });
    
    it('should not create a user if the email is invalid',function(done){
        var user = new User({
            email: "testCreateUser2",
            password: "testCreateUser2",
            title: "My new collection",
            slug: "valid_url2"
        });
        user.save(function(err){
            should.exist(err)
            done();
        });
    });
    
    it('should not create a user if there is no password',function(done){
        var user = new User({
            email: "testCreateUser3@test.com",
            title: "My new collection",
            slug: "valid_url3"
        });
        user.save(function(err){
            should.exist(err)
            done();
        });
    });
    
    
    it('should not create a user if the password length < 8',function(done){
        var user = new User({
            email: "testCreateUser4@test.com",
            password: "smaller",
            title: "My new collection",
            slug: "valid_url4"
        });
        user.save(function(err){
            should.exist(err)
            done();
        });
    });
    
    it('should hash the password',function(done){
        var pass = "testpassword"
        var user = new User({
            email: "testCreateUser5@test.com",
            password: pass,
            title: "My new collection",
            slug: "valid_url5"
        });
        user.save(function(err,saved){
            match = saved.comparePassword(pass,function(err,match){
                match.should.equal(true);
                done();
            });
        });
    });
    
    it('should not create a user if there is no title',function(done){
        var user = new User({
            password: "testCreateUser6",
            email: "testCreateUser6@test.com",
            slug: "valid_url6"
        });
        user.save(function(err){
            should.exist(err)
            done();
        });
    });

    it('should not create a user if there is no slug',function(done){
        var user = new User({
            password: "testCreateUser7",
            email: "testCreateUser7@test.com",
            title: "test title"
        });
        user.save(function(err){
            should.exist(err)
            done();
        });
    });

    it('should not create a user if the slug is invalid',function(done){
        var user = new User({
            password: "testCreateUser7",
            email: "testCreateUser7@test.com",
            title: "test title",
            slug: "invalid slug"
        });
        user.save(function(err){
            should.exist(err)
            done();
        });
    });
    after(function(done){
        mongoose.connection.collections['aggregate'].drop(function(err){
            require('../../../db').stop(done);
        });
    });
});
