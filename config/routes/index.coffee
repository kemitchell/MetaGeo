app = require '../middleware'
passport = require '../middleware/passport'
userController = require '../../controllers/userController'

app.post '/session', 
	passport.authenticate 'local',
		failureRedirect: '/session'
	(req,res)->
		res.redirect '/'
app.delete '/session', (req,res)->
	req.logout()
	res.redirect '/'

app.get '/user/:id', userController.find
app.post '/user', userController.create
app.delete '/user/:id', userController.delete

module.exports = app