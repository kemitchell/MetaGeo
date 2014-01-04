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
gjVal = require "geojson-validation"
utils = require '../utils'


#define generic logic for event CRUD
generic = new Generic
  #allow subscribable queries
  pubsub: true
  #fields to omit
  omit: ['objectType']
  #get the model based on the query
  model: (params)->
    if params.objecType then params.objecType.toLocaleLowerCase()

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

      validate: (point)->
        if not gjVal.isPoint(point)
          return "invalid geoJSON"
  
  #checks to be done before modifing operation (update/delete) take place
  check: (model, req) ->
    #check if the user who created the object is the one deleting it
    if req.auth.credentials.username is model.actor
      return true
    return false


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
      box: (box)->
        return {geometry:{$geoWithin:{$geometry: utils.bboxToPoly(box)}}}

      #find events within a geoJSON polygon
      poly: (poly)->
        if _.isString poly
          poly = JSON.parse poly
        return {geometry:{$geoWithin:{$geometry:{type:"Polygon",coordinates: poly}}}}

      #find events near a location
      near: (near, params)->
        if params["distance"]
          distance = params["distance"]
        else
          distance = 9000
        if not _.isArray near
          near = near.split ','
        near = near.map (e)->
          Number e
        return {geometry:{$near:{$geometry:{type:"Point", coordinates:near},$maxDistance:distance}}}

    #wraps the found events
    after: (vals, action ,options)->
      #options.sub
      #  sockets.subscribe options.sub, options.where
      wrapped =
        serverTime: (new Date()).toJSON()
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
  delete: generic.delete()

module.exports = EventController
