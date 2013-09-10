###
  :: Auth
  -> controller
###

pass = require('pwd')
User = require("../models/user")

AuthController =
  process: (request) ->
    password = request.payload.password
    if not request.payload.username or not password
      return @replay 'Missing username or password'

    User.findOne {username:request.payload.username}, (err, user)->
      if err
        return @reply(err)

      pass.hash password, user.salt, (err, hash)->
        if user.hash is hash.toString()
          request.auth.session.set(user)
          return request.reply(user)
        return request.reply({ message: 'Invalid Password'})

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
