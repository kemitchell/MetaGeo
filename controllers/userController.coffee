###
  :: User
  -> controller
###

User = require("../models/user")
generic = require('./generic')
generic(User)


UserController =
  find: generic.find()
  create: generic.create()
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
