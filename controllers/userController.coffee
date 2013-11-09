###
  :: User
  -> controller
###

pass = require 'pwd'
_ = require 'lodash'
User = require '../models/user'
Hapi = require 'hapi'
Generic = require('./generic')

generic = new Generic
  model: User
  fields:
    username:
      to: (current)->
          mongoIdRegex = /^[0-9a-fA-F]{24}$/
          if mongoIdRegex.test current
            return '_id'
          return 'username'
  check: (model, req) ->
   #user can only modify themselves
    if req.auth.credentials.username is model.username
      return true
    return false

UserController =
  findOne: generic.findOne()
  create: (request) ->
    #salt passwords
    pass.hash request.payload.password, (err, salt, hash) ->
      if(err)
        #something went wrong with hashing
        herror = Hapi.error.badRequest(err.message)
        return request.reply herror

      params = _.merge request.payload, {hash: hash, salt: salt }
      #params.title = params.username
      # don't save the password
      delete params.password
      #create a new user and save it
      user = new User(params)
      user.save (err) ->
        if err
          # 11000 is the mongo error code for dupicalate entries
          if err.code is 11000
            #extract the field name from the mongo error message
            field = err.err.match(/\$(.*?)_/)[1]
            message = {}
            message[field] =  field + " already exists. Please use a different one"
            error = Hapi.error.badRequest()
            #refommating in Boom will turn the message object in to an empty string
            error.response.payload.message = message
          else
            error = Hapi.error.badRequest(err.err)

          return request.reply error
        else
          return request.reply user
  
  update: generic.update()
  delete: generic.delete(
    after: (model, req )->
      #logout for the last time :(
      req.auth.session.clear()
  )

module.exports = UserController
