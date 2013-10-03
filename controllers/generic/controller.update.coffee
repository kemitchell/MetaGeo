###
CRUD update
###

module.exports = (context) ->

  _ = require('lodash')
  (request) ->

    params = _.merge request.params, request.query
    id = params.id
    if not id
      return request.reply '400 Bad Request: No id provided.'

    # Grab model class based on the controller this blueprint comes from 
    # If no model exists, move on to the next middleware
    if context.parent.getModel?
      Model = context.parent.getModel(request)
    else if context.parent.model
      Model = context.parent.model
    

    #never update the id
    delete params['id']

    # Otherwise find and update the models in question
    Model.findByIdAndUpdate id, request.payload, (err, model) ->
      if err
        request.reply err
      if not model
        return request.reply(Hapi.error.notFound("model with id of" + params.id + " not found"))
      return request.reply(model)
