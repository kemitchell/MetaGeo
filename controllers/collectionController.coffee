###
  :: Collection
  -> controller
###

Collection = require("../models/collection")
generic = require('./generic')
generic(Collection)

CollectionController =
  find: generic.find()
  create: generic.create(
    fields:
      actor: (user, parmas, req) ->
        return req.auth.credentials.id
  )
  update: generic.update()
  delete: generic.delete(
    check: (req, model) ->
      #check if the user who created the object is the one deleting it
      if req.auth.credentials.id is model.actor
        return true
      return false
  )

module.exports = CollectionController
