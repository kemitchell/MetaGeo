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

    if context?.options?.before?
      context.options.before params

    #field manipulation and validation
    fields =  context.options.fields or context.parent.fields
    if fields
      for  index, field of fields
        if field.to
          if params[index]
            if _.isFunction field.to
              field.to = field.to(params[index])
            params[field.to] = params[index]
            delete params[index]

    Model.findOne(params).exec (err, model)->
      if err
        return request.reply Hapi.error.internal err
      if not model
        return request.reply Hapi.error.notFound Model.modelName + " with id of" + params.id + " not found"

      return request.reply model
