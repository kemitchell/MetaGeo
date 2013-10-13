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
    username = request.payload.username
    if not username
      return request.reply Hapi.error.badRequest 'Missing UserName'

    if not password
      return request.reply Hapi.error.badRequest 'Missing Password'

    User.findOne {username:username}, (err, user)->
      if err
        return @reply Hapi.error.internal err

      if user
        pass.hash password, user.salt, (err, hash)->
          if user.hash is hash.toString()
            request.auth.session.set user
            user = user.toJSON()
            user.authenticated = true
            return request.reply user
          #invalid password
          return request.reply Hapi.error.badRequest 'Invalid User or Password'
      else
        #invalid user
        request.reply Hapi.error.badRequest 'Invalid User or Password'

  status: () ->
    if @auth.isAuthenticated
      @auth.credentials.authenticated = true
      return @reply @auth.credentials
    else
      return @reply {authenticated: false}

  logout: () ->
    @auth.session.clear()
    return @reply {authenticated: false}

module.exports = AuthController
