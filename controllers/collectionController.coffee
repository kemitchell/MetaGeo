###
  :: Collection
  -> controller
###

Collection = require("../models/collection")
generic = require('./generic')
generic.model = Collection

CollectionController =
  find: generic.find()
  create: generic.create(
    fields:
      actor: (user, parmas, req) ->
        return req.user.id
  )
  update: generic.update()
  delete: generic.delete(
    check: (req, model) ->
      #check if the user who created the object is the one deleting it
      if req.user.id is model.actor
        return true
      return false
  )

module.exports = CollectionController
