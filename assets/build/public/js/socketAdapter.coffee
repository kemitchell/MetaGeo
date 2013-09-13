define (require) ->
  require('socketjs-client')
  sockjs_url = '/echo'
  sock = new SockJS(sockjs_url)

  sock.onopen = ()->
    console.log('open')

  sock.onmessage = (e)->
    console.log('message', e.data)

  sock.onclose = ()->
    console.log('close')

  #set up sockets.io
  #socket = io.connect("?bounds=[-90,90]")
  #create a global refrance to the current socket
  #window.socket = socket
  #socket.on 'connect', ()->
   # socket.on 'message', (message)->
    #  if message.model is 'event' and message.verb is 'create'
     #   window.vent.trigger('eventAdd', message.data)
      #console.log("new message", message)
