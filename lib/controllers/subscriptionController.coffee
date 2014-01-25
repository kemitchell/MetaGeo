Generic = require './generic'
Subscription = require '../models/subscription'
utils = require '../utils'
_ = require 'lodash'

#define generic logic for event CRUD
generic = new Generic
  model: Subscription
  fields:
    _id: (_id, params)->
      if params.id
        _id = params.id
      return _id

    client:
      validate: (client)->
        if not client
          return "client required"

    transports:
      transform: (trans, params, request)->
        clientTransports = []
        if params.client
          for index, transport of request.server.plugins['metageo-pubsub'].transports
            #if a client exists on a transport then publish the model
            if _.isFunction(transport.getClient) and transport.getClient params.client
              clientTransports.push index
        return clientTransports

      validate: (transports)->
        if transports.length is 0
          return "no transport found for client"

    filter: (filter, params)->
      returnFilter =
        near: undefined
        geometry: undefined

      filterFields = ['objectType', 'collection' ,'actor', 'start', 'near', 'distance', 'poly', 'box']
      if not filter
        filter = _.pick params, filterFields

      if not _.isEmpty filter
        if filter.near and filter.distance
          returnFilter.geometry = utils.circleToPoly(filter.near, filter.distance)

        else if filter.box
          returnFilter.geometry = utils.bboxToPoly filter.box

        else if filter.poly
          returnFilter.geometry =
            type: "Polygon"
            filter: filter.poly

      return returnFilter

###
The Controller, handles CRUD for events
@class EventController
@static
###
SubscriptionController =
  create: generic.create(
    after:(model)->
      for transport in model.transports
        pubsub.transports[transport].sub(model.get('client'), model.get('_id').toString(), model.get('filter'))
  )
  update: generic.update()
  delete: generic.delete()

module.exports = SubscriptionController
