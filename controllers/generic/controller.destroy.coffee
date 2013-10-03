###
CRUD delete
###

module.exports = (context) ->
  Hapi = require('hapi')
  _ = require('lodash')
 
  (request) ->
    params = _.merge request.params, request.query
    if not params.id
      return request.reply '400 Bad Request: No id provided.'

    # Grab model class based on the controller this blueprint comes from 
    # If no model exists, move on to the next middleware
    if context.parent.getModel?
      Model = context.parent.getModel(request)
    else if context.parent.model
      Model = context.parent.model

    if context?.options?.before?
      context.options.before params
    
    # Otherwise, find and destroy the model in question

    #if context.options?.check? and _.isFunction(context.options.check)
    #  if not context.options.check req, result
    #    return res.send 401, 'Not Allowed'

    Model.findByIdAndRemove params.id, (err, result) ->

      if context?.options?.after?
        model = context.options.after(result, params)

      if err
        return request.reply err

      # Respond with model which was destoryed
      if result
        return request.reply(result)

      return request.reply(Hapi.error.notFound("model with id of" + params.id + " not found"))
