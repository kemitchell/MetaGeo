###
Socket Functions
###
sockjs      = require 'sockjs'
_           = require 'lodash'
sockets     = {}
connections = {}
openQueries = {}
Mblog       = require './models/mblog'
Social      = require './models/social'
Event       = require './models/event'


sockets =
  ###
  Starts socksjs
  @method start
  @param {Object} listener
  d@param {Object} options options for sockjs from the config file
  ###
  start: (server, options)->
    sserver = sockjs.createServer options
    sserver.installHandlers server.listener
    sserver.on 'connection', (conn)->
      #header = conn.header
      #authentication = 
      connections[conn.id] = conn
      conn.write JSON.stringify {'connack':{'sessionId': conn.id}}
      conn.on 'data', (message)->
        switch message.action
          #when 'publish'
          #when 'subscribe'
          when 'unsubscribe'
            if conn.unsubscribe
              conn.unsubscribe()

      conn.on 'close', ()->
        if conn.unsubscribe then conn.unsubscribe()
        delete connections[conn.id]

    Mblog.on 'add', (model)=>
      @onAction model, 'create'
    Social.on 'add', (model)=>
      @onAction model, 'create'
    Mblog.on 'change', (model)=>
      #a hack because mongoose-eventify mess with isNew
      if not model._isNew
        @onAction model, 'update'
    Social.on 'change', (model)=>
      if not model._isNew
        @onAction model, 'update'
  ###
  Broadcast changes  when a model is updated, delete, created or modified to 
  the appropate clients
  @method onAction
  @param {Object} model the model that is being broadcasted
  @param {String} action
  ###
  onAction: (model, action)->
    #iterate thought the filters
    for index, query of openQueries
      #only select events that new or equal to this event.
      filter = query.filter
      #if subscribed to all skip requering
      if filter is {}
        response =
          publish:
            model: model.toJSON()
            action: action
        string = JSON.stringify response
        #publish to every listening 
        for sid in query.sids
          connections[sid].write string
      else
        #requery the event to make to see if it fits in any of the filters
        filter._id = model.id
        Event.find(filter).exec (err, results)->
          if results
            #for every found event
            for result in results
              response =
                publish:
                  model: result.toJSON()
                  action: action
              string = JSON.stringify response
              #publish to every listening 
              for sid in query.sids
                connections[sid].write string
  ###
  a helper function that broadcast a message to all connections
  @method broadcast
  @param {*} message
  ###
  broadcast: (message, action)->
    data =
      publish: {}
      topic: 'none'
     
    data.publish[action] = message
    data = JSON.stringify data
    for id, connection of connections
      connection.write data


  
  ###
  sends a stream to an client identified by their sid
  ###
  subscribe: (sid, filter, Model)->
    conn = connections[sid]
    index = JSON.stringify filter
    #check if we have a connection and that it is not already subscribed to the given filter
    if conn?.filter isnt index
      conn.filter = index
      #send the subscription acknolagement
      conn.write JSON.stringify {'suback':index}
      #unsubscribe if subscribed to another filter
      if conn.unsubscribe
        conn.unsubscribe()
      #open a new tailable cursor if nessicary
      if index not in openQueries
        openQueries[index] =
          filter: filter
          sids: [sid]
      else
        openQueries[index].sids.push sid

      conn.unsubscribe = ()->
        openQueries[index].sids = _.without(openQueries[index].sids, sid)
        if openQueries[index].sids.length is 0
          delete openQueries[index]

    else
      return false

  unsubscribe: (sid)->
    conn = connections[sid]
    conn.unsubscribe()

module.exports = sockets
