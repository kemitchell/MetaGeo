###
CRUD update
###
Hapi = require('hapi')
_ = require('lodash')

module.exports = (context) ->
  (request) ->

    params = _.merge request.query, request.params

    if context?.options?.before?
      context.options.before params

    # Grab model class based on the controller this blueprint comes from 
    # If no model exists, move on to the next middleware
    Model = context.options.getModel or context.options.model or context.parent.getModel or context.parent.model
    if not Model.modelName?
      Model = Model params
    
    #for that wierd edge case
    delete params['objectType']

    if params.id
      params._id = params.id
      delete params.id

    Model.findOneAndUpdate params, request.payload, (err, model) ->
      if context?.options?.after?
        model = context.options.after model, params

      if err
        return request.reply Hapi.error.internal err
      if not model
        return request.reply Hapi.error.notFound(Model.modelName + " with id of" + params.id + " not found")
      return request.reply model
