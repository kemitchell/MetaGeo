define (require) ->

  Backbones = require('backbone')
  io = require('socket.io-client')
  require('js/sails.io.js')

  #set up sockets.io
  socket = io.connect("?bounds=[-90,90]")
  #create a global refrance to the current socket
  window.socket = socket
  socket.on 'connect', ()->
    socket.on 'message', (message)->
      if message.model is 'event' and message.verb is 'create'
        window.vent.trigger('eventAdd', message.data)
      #console.log("new message", message)
