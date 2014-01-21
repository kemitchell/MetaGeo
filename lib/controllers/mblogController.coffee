###
The Mblog Controller
###

MblogController = new (require('./eventController'))({model: require '../models/mblog'})
delete MblogController.update
module.exports = MblogController
