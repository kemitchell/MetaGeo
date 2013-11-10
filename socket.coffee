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
  echo = sockjs.createServer(options)
  echo.installHandlers listener
  echo.on 'connection', (conn)->
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
sockets.broadcast = (message)->
  for id, connection of connections
    connection.write(JSON.stringify(message))

module.exports = sockets
