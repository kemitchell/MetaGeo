###
  :: Event
  -> controller
###

_ = require("lodash")
Event = require("../models/event")
generic = require('./generic')
generic(Event)

EventController =
  find: generic.find(
    maxLimit: 30
    defaultOrder: "startDateTime ASC"
    query: (query, params) ->
      if params['bbox']
        query.where.geometry = { $geoWithin :{ $geometry : { type : "Polygon" ,coordinates: [ [ [ -87.885132, 42.051332] , [ -87.533569, 42.051332] , [ -87.533569, 41.71393 ] , [ -87.885132, 42.051332 ] ] ] } } }
      return query
    result: (vals, query)->
      wrapped =
        items: vals
        query: query
        pages:
          more: true

      if vals.length < query.limit
        wrapped.more = false

      wrapped.pages.next = wrapped.pages.prev = "?limit=" + query.limit
      wrapped.pages.next += "&offset=" + ((query.skip or 0) + query.limit)
      wrapped.pages.prev += "&offset=" + (- query.limit + (query.skip or 0))

      if not _.isEmpty(wrapped.query.where)
        where = "&where=" + JSON.stringify(wrapped.query.where)
        wrapped.pages.next += where
        wrapped.pages.prev += where

      return wrapped
  )
  create: generic.create(
    fields:
      # give the event an author
      actor: (actor, params, req) ->
        return req.auth.credentials.id
      #check and progagete event s
      collections: (collections) ->
        if collections
          if not _.isArray(collections)
            #set collections to an array
            collections = [collections]
        return collections

      geometry: (geometry, params)->
        if params['lat'] and params['lng']
          geometry =
            type: "Point"
            coordinates: [params['lng'], params['lat']]
        return geometry
    #add custom validation
    validators:
      geometry:
        required: true
  )
  update: generic.update()
  delete: generic.delete(
    check: (req, model) ->
      #check if the user who created the object is the one deleting it
      if req.user.id is model.actor
        return true
      return false
  )

module.exports = EventController
