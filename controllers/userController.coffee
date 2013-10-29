###
  :: User
  -> controller
###

_ = require 'lodash'
User = require '../models/user'
Hapi = require 'hapi'
generic = new require('./generic')()
generic.model = User
pass = require 'pwd'

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
      params.title = params.username
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
