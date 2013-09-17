sockjs = require('sockjs')
sockets = {}
connections = {}

sockets.start = (listener)->
  echo = sockjs.createServer()

  echo.installHandlers(listener, {prefix:'/echo'})

  echo.on 'connection', (conn)->
    connections[conn.id] = conn
    conn.on 'data', (message)->
      conn.write(message)

    conn.on 'close', ()->
      delete connections[conn.id]

sockets.stop = (cb)->
  console.log("stopping sockets")

sockets.broadcast = (message)->
  for id, connection of connections
    connection.write(JSON.stringify(message))

module.exports = sockets
