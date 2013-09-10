###
this a generic create for sailsjs
@class generic create
###
Hapi = require('hapi')

module.exports = (context) ->

  _ = require('lodash')

  (request) ->

    if context.globals
      Model = context.globals
    else
      return request.reply '400 Bad Request: No Model provided.'

    params = _.merge request.params, request.query, request.payload
    #check for field option
    if context?.options?.fields?
      fields = _.transform context.options.fields, (result, func, index) ->
        if _.isFunction(func)
          #get the value of the paramter being manuplated
          func = func(request.query[index], params, request)
        result[index] = func

      _.extend(params, fields)

    #check for validators
    if context?.options?.validators?
      for field, validator of context.options.validators
        #check if the attrubite actully exsits first
        #if Model._validator.validations[field]?ndRemove
        #  _.extend( Model._validator.validations[field], validator )
        console.log("to implent")

    Model.create params, (err, model) ->
      if(err)
        herror = Hapi.error.badRequest(err.message)
        return request.reply herror

      #otherwire return JSON
      return request.reply(model)
