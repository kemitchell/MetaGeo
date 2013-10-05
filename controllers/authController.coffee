###
  :: Auth
  -> controller
###

pass = require 'pwd'
Hapi = require 'hapi'
User = require "../models/user"

AuthController =
  process: (request) ->
    password = request.payload.password
    if not request.payload.username or not password
      return @reply 'Missing username or password'

    User.findOne {username:request.payload.username}, (err, user)->
      if err
        return @reply(err)

      if user
        pass.hash password, user.salt, (err, hash)->
          if user.hash is hash.toString()
            request.auth.session.set user
            return request.reply user
          #invalid password
          return request.reply Hapi.error.badRequest 'Invalid User or Password'
      else
        #invalid user
        request.reply Hapi.error.badRequest 'Invalid User or Password'

  status: () ->
    if @auth.isAuthenticated
      @auth.credentials.authenticated = true
      return @reply(@auth.credentials)
    else
      return @reply({authenticated: false})

  logout: () ->
    @auth.session.clear()
    return @reply({authenticated: false})

module.exports = AuthController
