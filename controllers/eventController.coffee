###
  :: Event
  -> controller
###

_ = require("lodash")
querystring = require("querystring")
Event = require("../models/event")
generic = require('./generic')
generic(Event)

bboxToPoly = (box)->
  if not _.isArray(box)
    box = box.split(',')

  box = box.map (e)->
    Number(e)

  box = [[[box[0], box[1]],[box[0], box[3]],[box[2], box[3]],[box[2], box[1]],[box[0], box[1]]]]

EventController =
  find: generic.find(
    maxLimit: 30
    defaultOrder: "startDateTime ASC"
    queries:
      box: (box, Event)->
        Event.find({geometry:{$geoWithin:{$geometry:{type:"Polygon",coordinates: bboxToPoly(box)}}}})

      poly: (poly, Event)->
        if _.isString(poly)
          poly = JSON.parse(poly)
        Event.find({geometry:{$geoWithin:{$geometry:{type:"Polygon",coordinates: poly}}}})

      near: (near, Event, params)->
        if params["distance"]
          distance = params["distance"]
        else
          distance = 9000
        if not _.isArray(near)
          near = near.split(',')
        near = near.map (e)->
          Number(e)
        Event.find({geometry:{$near:{$geometry:{type:"Point", coordinates:near},$maxDistance:distance}}})

    result: (vals, options)->
      wrapped =
        items: vals
        pages:
          more: true

      if vals.length < options.limit
        wrapped.pages.more = false

      wrapped.pages.next = "offset=" + ((options.skip or 0) + options.limit)
      wrapped.pages.prev = "offset=" + (- options.limit + (options.skip or 0))

      delete options.skip
      where = querystring.stringify(options)
      wrapped.pages.next += "&" + where
      wrapped.pages.prev += "&" + where

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
