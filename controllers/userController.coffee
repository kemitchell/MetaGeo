###
User Controller
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

###
The User Controller, handles CRUD for users
@class UserController
@static
###
UserController =
  ###
  finds a user
  @method findOne
  ###
  findOne: generic.findOne()

  ###
  creates a user and hashes their password
  @method create
  ###
  create: (request) ->
    #validate payload for hashing
    password = request.payload.password
    username = request.payload.username
    if not username
      return request.reply Hapi.error.badRequest 'Missing UserName'

    if not password
      return request.reply Hapi.error.badRequest 'Missing Password'

    #salt passwords
    pass.hash request.payload.password, (err, salt, hash) ->
      if(err)
        #something went wrong with hashing
        return request.reply Hapi.error.internal(err.message)

      params = _.merge request.payload, {hash: hash, salt: salt }
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
            error = {}
            error[field] =  field + " already exists. Please use a different one"
          else
            error = err.err
          return request.reply Hapi.error.badRequest(error)
        else
          return request.reply user
  
  ###
  Updates an user 
  @method update
  ###
  update: generic.update()

  ###
  Deletes an user 
  @method delete
  ###
  delete: generic.delete(
    after: (model, req )->
      #logout for the last time :(
      req.auth.session.clear()
  )

module.exports = UserController
