###
CRUD update
###
Hapi = require('hapi')
_ = require('lodash')

module.exports = (context) ->
  (request) ->

    params = request.params
    payload = request.payload

    if context?.options?.before?
      context.options.before params

    # Grab model class based on the controller this blueprint comes from 
    # If no model exists, move on to the next middleware
    Model = context.options.getModel or context.options.model or context.parent.getModel or context.parent.model
    if not Model.modelName?
      Model = Model params

    #field manipulation and validation
    fields =  context.options.fields or context.parent.fields
    if fields
      for  index, field of fields
        if _.isFunction field
          result = field payload[index], payload, request
          if result
            payload[index] = result

        else
          if _.isFunction field.transform
            #get the value of the paramter being manuplated
            result = field.transform payload[index], payload, request
            if result
              payload[index] = result

          #run validation
          if _.isFunction field.validate
            err = field.validate payload[index], payload, request
            if err
              herror = Hapi.error.badRequest err
              return request.reply herror

          if field.to
            if params[index]
              if _.isFunction field.to
                field.to = field.to(params[index])
              params[field.to] = params[index]
              delete params[index]

    Model.findOneAndUpdate params, payload, (err, model) ->
      if context?.options?.after?
        model = context.options.after model, params

      if err
        return request.reply Hapi.error.internal err
      if not model
        return request.reply Hapi.error.notFound(Model.modelName + " with id of" + params.id + " not found")
      return request.reply model
