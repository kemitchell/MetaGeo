###
The Event Controller, handles CRUD for events
###

_ = require 'lodash'
querystring = require 'querystring'
config = require '../config'
Event = require '../models/event'
Social = require '../models/social'
Mblog = require '../models/mblog'
List = require '../models/list'
Generic = require './generic'

#create a new generic controller
generic = new Generic
  #get the model based on the query
  model: (params)->
    if params.objecType then params.toLocaleLowerCase()

    if params.objectType is "social"
      return Social
    else if params.objectType is "mblog"
      return Mblog
    else
      return Event

  fields:
    # give the event an author
    actor: (actor, params, req) ->
      return req.auth.credentials.username

    lists:
      transform: (lists) ->
        if lists
          if not _.isArray lists
            #set collections to an array
            lists = [lists]
        return lists
      validate: (lists)->
        if lists and lists.length > config.api.events.maxLists
          return "the max number of lists you can add an event to is:" +  config.api.events.maxLists

    geometry:
      transform: (geometry, params)->
        if params['lat'] and params['lng']
          geometry =
            type: "Point"
            coordinates: [Number(params['lng']),Number(params['lat'])]
        return geometry

###
A helper function that changes a bounding box into a geojson polygon
@method bboxToPoly
@param box a bounding box give two comma seperated cooridantes
###
bboxToPoly = (box)->
  if not _.isArray box
    box = box.split ','

  box = box.map (e)->
    Number e

  box = [[[box[0], box[1]],[box[0], box[3]],[box[2], box[3]],[box[2], box[1]],[box[0], box[1]]]]

###
The Event Controller, handles CRUD for events
@class EventController
@static
###
EventController =
  ###
  @method findOne
  ###
  findOne: generic.findOne()

  ###
  @method find
  ###
  find: generic.find(
    #max number of events to return
    maxLimit: config.api.events.maxLimit
    defaultOrder: config.api.events.defaults.order
    #scans the query string of these method and if they exists exicutes thems
    queries:
      #find events within a bounding box
      box: (box, Event)->
        Event.find {geometry:{$geoWithin:{$geometry:{type:"Polygon",coordinates: bboxToPoly(box)}}}}

      #find events within a geoJSON polygon
      poly: (poly, Event)->
        if _.isString poly
          poly = JSON.parse poly
        Event.find {geometry:{$geoWithin:{$geometry:{type:"Polygon",coordinates: poly}}}}

      #find events near a location
      near: (near, Event, params)->
        if params["distance"]
          distance = params["distance"]
        else
          distance = 9000
        if not _.isArray near
          near = near.split ','
        near = near.map (e)->
          Number e
        Event.find {geometry:{$near:{$geometry:{type:"Point", coordinates:near},$maxDistance:distance}}}

    #wraps the found events
    after: (vals, options)->
      wrapped =
        items: vals
        pages:
          more: true

      if vals.length < options.limit
        wrapped.pages.more = false

      wrapped.pages.next = "offset=" + ((options.skip or 0) + options.limit)
      wrapped.pages.prev = "offset=" + (- options.limit + (options.skip or 0))

      delete options.skip
      delete options.offset
      where = querystring.stringify options
      wrapped.pages.next += "&" + where
      wrapped.pages.prev += "&" + where

      return wrapped
  )

  ###
  @method create
  ###
  create: generic.create(
    model: (params)->
      if params.objectType is "social"
        return Social
      else if params.objectType is "mblog"
        return Mblog
      return Mblog
    
    #fields to omit
    omit: ['objectType']
  )

  ###
  @method update
  ###
  update: generic.update(
    #only update socail events
    model: Social
  )

  ###
  @method delete
  ###
  delete: generic.delete(
    check: (model, req) ->
      #check if the user who created the object is the one deleting it
      if req.auth.credentials.username is model.actor
        return true
      return false
  )

module.exports = EventController
