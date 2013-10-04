app = require './config/routes'
http = require 'http'
db = require('./config/db').start()


http.createServer(app).listen app.get('port'), ()->
	 console.log('listening')