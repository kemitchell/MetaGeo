###
Socket Functions
###
EventEmitter = require('events').EventEmitter
sockjs      = require 'sockjs'
_           = require 'lodash'
sockets     = {}
connections = {}
openStreams = {}

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
  subscribe: (sid, filter, Model, reconnecting)->
    conn = connections[sid]
    index = JSON.stringify _.omit(filter,'updated')
    #check if we have a connection and that it is not already subscribed to the given filter
    if reconnecting or (conn?.tail?.filter isnt index)
      #send the subscription acknolagement
      if not reconnecting
        conn.write JSON.stringify {'suback':index}
        #unsubscribe if subscribed to another filter
        if conn.unsubscribe
          conn.unsubscribe()
      
        #open a new tailable cursor if nessicary
        if not openStreams[index]
          #console.log((new Date()).toISOString())
          filter.updated = {$gte: new Date()}

      openStreams[index] = Model.find(filter).tailable().stream()
      openStreams[index].filter = index

      tail = conn.tail = openStreams[index]

      onData = (message)->
        data =
          publish: {}
          topic: index
         
        data.publish = message
        data.action = message.action
        data = JSON.stringify data
        conn.write data

      conn.unsubscribe = ()->
        tail.removeListener 'data', onData
        #no one is listening. Destory the cursor
        if EventEmitter.listenerCount(tail, 'on') is 0
          tail.removeAllListeners 'data'
          tail.removeAllListeners 'end'
          tail.destroy()
          delete openStreams[tail.filter]
        console.log('unsubcribe')

      tail.on 'data', onData
      tail.once 'end', (message)=>
        console.log 'stream closed ' + tail.filter
        Model.once 'add', (model)=>
          #console.log model.toJSON()
          console.log 'stream reconnecting'
          @subscribe(sid, filter, Model, true)
    else
      return false

  unsubscribe: (sid)->
    conn = connections[sid]
    conn.unsubscribe()

module.exports = sockets
