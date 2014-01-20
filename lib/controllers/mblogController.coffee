###
The Mblog Controller
###

MblogController = new (require('./eventController'))({model: require '../models/mblog'})
module.exports = MblogController
