###
Authentication Controller, handles logging in and out
###

pass = require 'pwd'
Hapi = require 'hapi'
User = require "../models/user"

AuthController =
  process: (request, reply) ->
    password = request.payload.password
    username = request.payload.username

    if not username
      return reply Hapi.error.badRequest
        fields:
          username: 'Username is Required'
        message: 'Missing Username'

    if not password
      return reply Hapi.error.badRequest
        fields:
          password: 'Password is Required'
        message: 'Missing Password'

    User.findOne {username:username}, (err, user)->
      if err
        return reply Hapi.error.internal err

      if user
        pass.hash password, user.salt, (err, hash)->
          if user.hash is hash.toString()
            request.auth.session.set user
            user = user.toJSON()
            user.authenticated = true
            return reply user
          #invalid password
          return reply Hapi.error.badRequest 'Invalid User or Password'
      else
        #invalid user
        reply Hapi.error.badRequest 'Invalid User or Password'

  status: (request, reply) ->
    if request.auth.isAuthenticated
      request.auth.credentials.authenticated = true
      return reply request.auth.credentials
    else
      return reply {authenticated: false}

  logout: (request, reply) ->
    request.auth.session.clear()
    return reply {authenticated: false}

module.exports = AuthController
