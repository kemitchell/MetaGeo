###
this a generic create controller
@class generic create
###
module.exports = (context) ->

  _ = require('lodash')

  (req,res,next) ->

    if context.globals
      Model = context.globals
    else
      return res.send 400, 'Bad Request: No Model provided.'

    params = _.merge req.params, req.query, req.body
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
        console.log("to implement")

    model = new Model(params)

    model.save (err,model)->
      if err
        return res.send 500, err
      res.send model