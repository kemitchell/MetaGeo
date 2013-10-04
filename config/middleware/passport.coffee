passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require('../../models/user')

passport.serializeUser (user, done)->
	done null, user.id

passport.deserializeUser (id, done)->
	User.findById id, (err, user)->
		done err, user

passport.use new LocalStrategy (username, password, done)->
	User.findOne 'username': username, (err, user)->
		if err
			return done err
		if not user 
			return done null, false, message: 'Unknown user '+username
		user.comparePassword password, (err, isMatch)->
			if err 
				return done err
			if isMatch
	  			return done null, user
			else
	  			return done null, false, message: 'Invalid password'

module.exports = passport