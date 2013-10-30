###
  :: User
  -> controller
###

_ = require 'lodash'
User = require '../models/user'
Hapi = require 'hapi'
generic = new require('./generic')()
pass = require 'pwd'
generic.model = User
generic.fields =
  #changes id to _id
  id:
    to: '_id'
  username:
    to: (current)->
        mongoIdRegex = /^[0-9a-fA-F]{24}$/
        if mongoIdRegex.test current
          return '_id'
        return 'username'

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

      user = new User(params)
      user.save (err) ->
        if err
          request.reply err
        request.reply user
  
  update: generic.update()
  delete: generic.delete(
    check: (req, model) ->
     #user can only delete themselves
      if req.user.id is model.id
        #logout for the last time :(
        req.logout()
        return true
      return false
  )

module.exports = UserController
