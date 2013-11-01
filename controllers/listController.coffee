###
  :: Collection
  -> controller
###
List = require "../models/list"
Aggergate = require "../models/aggregate"
Generic = require('./generic')
generic = new Generic
  model:List

  #checks to be done before modifing operation (update/delete) take place
  check: (model, req) ->
    #check if the user who created the object is the one deleting it
    if req.auth.credentials.username is model.actor
      return true
    return false

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
  delete: generic.delete()

module.exports = ListController
