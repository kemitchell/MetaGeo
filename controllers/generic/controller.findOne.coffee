###
CRUD findOne
###
_ = require 'lodash'
Hapi = require 'hapi'

module.exports = (context) ->

  (request) ->
    params = _.merge request.query, request.params

    Model = context.options.getModel or context.options.model or context.parent.getModel or context.parent.model
    if not Model.modelName?
      Model = Model params

    if params.id
      params._id = params.id
      delete params.id
    
    if context?.options?.before?
      context.options.before params

    Model.findOne(params).exec (err, model)->
      if err
        return request.reply Hapi.error.internal err
      if not model
        return request.reply Hapi.error.notFound Model.modelName + " with id of" + params.id + " not found"

      return request.reply model
