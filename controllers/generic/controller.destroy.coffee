###
CRUD delete
###
Hapi = require('hapi')
_ = require('lodash')

module.exports = (context) ->
 
  (request) ->
    params = _.merge  request.query, request.params

    if context?.options?.before?
      context.options.before params


    Model = context.options.getModel or context.options.model or context.parent.getModel or context.parent.model
    if not Model.modelName?
      Model = Model params

    if params.id
      params._id = params.id
      delete params.id

    Model.findOneAndRemove params, (err, result) ->
      if context?.options?.after?
        model = context.options.after result, params

      if err
        return request.reply err

      # Respond with model which was destoryed
      if result
        return request.reply(result)

      return request.reply Hapi.error.notFound("model with id of" + params.id + " not found")
