express = require 'express'
app = express();
RedisStore = require('connect-redis')(express)
passport = require './passport'
path = require 'path'

app.set 'port', process.env.PORT || 3000
app.set 'views', __dirname+'/views'
app.set 'view engine', 'jade'
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session
	store: new RedisStore
		host: process.env.IP
		port: 16379
	secret: 'secretstuff'
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))

module.exports = app