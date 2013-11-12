###
Socket Functions
###

sockjs      = require('sockjs')
sockets     = {}
connections = {}

###
Starts socksjs
@method start
@param {Object} listener
@param {Object} options options for sockjs from the config file
###
sockets.start = (listener, options)->
  server = sockjs.createServer(options)
  server.installHandlers listener
  server.on 'connection', (conn)->
    connections[conn.id] = conn
    conn.on 'data', (message)->
      conn.write(message)

    conn.on 'close', ()->
      delete connections[conn.id]

###
a helper function that broadcast a message to all connections
@method broadcast
@param {*} message
###
sockets.broadcast = (message, action)->
  for id, connection of connections
    connection.write JSON.stringify {action:action, model: message}

module.exports = sockets
