Subscription = require './models/subscription'
mongoose = require 'mongoose'
_ = require 'lodash'
uuid = require 'uuid'
utils = require './utils'

pubsub =
  transports: {}
  ###
  Start all the transports this node know about
  @method start
  @param {Object} config passed in though the config file
  ###
  start: (server, config, cb)->
    @server = server
    for transport, transconfig of config.transports
      @transports[transport] = require(transport)
      @transports[transport].start(transconfig, @, server.listener)
      #TODO: make this do what its suppose too
      if _.isFunction cb
        cb()

  ###
  Shutdown the transports
  @method stop
  ###
  stop: ()->
    #clear the subscription collection
    mongoose.connection.collections.subscriptions.remove (err)->
      console.log('subscription cleared')
    for index, transport of @transports
      transport.stop()

  ###
  Publish a model, finds the subscriptions that match it and then publishes the
  model to the transports of the subscription 
  @method pub
  @param {Object} model 
  @param {String} action, what is happening to the model
  ###
  pub: (model, action)->
    promise = Subscription.aggregate(
      $match:{$or: [{"filter.geometry":{$geoIntersects:{$geometry: model.geometry}}},{"filter.geometry.type":  $exists:false}]}
      ).exec (err, subscriptions)=>
        if not err
          #iterate thourgh teh subscriptions
          for subscription in subscriptions
            p1 = subscription.filter.near
            p2 = model.geometry.coordinates
            #if the subscription was to `near` objects then calculate the distace
            #to see of the event model is near enought
            if p1 and  subscription.filter.distance > utils.distance(p1[0], p1[1], p2[0], p2[1]) or not p1
              clientID = subscription.client
              #iterate thourght the transports
              for transport in subscription.transports
                @transports[transport].pub clientID, model, action

  ###
  Creates a subscription given a clientID and filter
  @method sub
  @param {String} clientID
  @param {Object} filter
  @param {String} id, an optional id for the subscription, if not given default
  mongo ids are used
  ###
  sub: (client, filter, id)->
    filter.client = client
    if id
      filter._id = id

    @server.inject  {method:'POST', url:'/api/subscription', payload: JSON.stringify(filter)}, (res)->

  ###
  Unsubscribes from a given a subscription
  @method unsub
  @param {String} clientID
  @param {Object} id the id of the subscription
  ###
  unsub: (clientID, id)->
    url = '/api/subscription/' + id + '?client=' + clientID
    @server.inject  {method:'DELETE', url:url}, (res)->


  ###

  @method sub
  @param {String} clientID
  @param {Object} filter
  @param {String} id, an optional id for the subscription, if not given default
  mongo ids are used
  ###
  rest: (method, url, payload)->
    @server.inject  {method:methid, url:url, payload: payload}, (res)->

module.exports = pubsub
