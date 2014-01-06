###
The Socail Controller, handles CRUD for requests
###

SocialController = new (require('./eventController'))({model : require '../models/social'})
module.exports = SocialController
