###
this is a generic create controller
@class generic create
###
Hapi = require('hapi')
socket = require('../../socket')
_ = require('lodash')

module.exports = (context) ->

  (request) ->

    params = _.merge request.query, request.payload, request.params
    Model = context.options.getModel or context.options.model or context.parent.getModel or context.parent.model
    if not Model.modelName?
      Model = Model(params)

    if context?.options?.before?
      context.options.before params

    #for that wierd edge case
    delete params['objectType']

    #check for field option
    if context?.options?.fields?
      fields = _.transform context.options.fields, (result, func, index) ->
        if _.isFunction(func)
          #get the value of the paramter being manuplated
          func = func(params[index], params, request)
        result[index] = func

      _.extend(params, fields)

    #check for validators
    if context?.options?.validators?
      for field, validator of context.options.validators
        #check if the attrubite actully exsits first
        #if Model._validator.validations[field]?ndRemove
        #  _.extend( Model._validator.validations[field], validator )
        console.log("to implent")

    model = new Model(params)

    model.save (err)->

      if context?.options?.after?
        model = context.options.after(model, params)

      if(err)
        herror = Hapi.error.badRequest(err.message)
        return request.reply herror
      socket.broadcast(model.toJSON())
      return request.reply(model.toJSON())
