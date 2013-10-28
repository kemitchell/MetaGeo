###
  :: Collection
  -> controller
###
List = require "../models/list"
generic = new require('./generic')()
generic.model = List

ListController =
  find: generic.find()
  create: generic.create(
    fields:
      actor: (actor, params, req) ->
        return req.auth.credentials.id
  )
  update: generic.update()
  delete: generic.delete(
    check: (req, model) ->
      #check if the user who created the object is the one deleting it
      if req.user.id is model.actor
        return true
      return false
  )

module.exports = ListController
