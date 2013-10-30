###
  :: Collection
  -> controller
###
List = require "../models/list"
Aggergate = require "../models/aggregate"
generic = new require('./generic')()
generic.model = List

generic.fields =
  #changes id to _id
  id:
    to: '_id'

ListController =
  findOne: generic.findOne(
    model: Aggergate
  )
  create: generic.create(
    fields:
      actor: (actor, params, req) ->
        return req.auth.credentials.username
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
