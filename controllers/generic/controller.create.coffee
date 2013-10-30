###
this is a generic create controller
@class generic create
###
Hapi = require 'hapi'
mongoose = require 'mongoose'
socket = require '../../socket'
_ = require 'lodash'

module.exports = (context) ->

  (request) ->

    payload = _.merge request.payload, request.params
    Model = context.options.getModel or context.options.model or context.parent.getModel or context.parent.model

    #get the model based of the params
    if not Model.modelName?
      Model = Model payload

    if context?.options?.before?
      context.options.before params

    #field manipulation and validation
    fields =  context.options.fields or context.parent.fields
    if fields
      for  index, field of fields
        if _.isFunction field
          payload[index] = field payload[index], payload, request

        else if _.isFunction field.transform
          #get the value of the paramter being manuplated
          payload[index] = field.transform payload[index], payload, request
          
          #run validation
          if _.isFunction field.validate
            err = field.validate payload[index], payload, request
            if err
              herror = Hapi.error.badRequest err
              return request.reply herror

    #create a new model
    model = new Model payload
    #and save it
    model.save (err)->
      if context?.options?.after?
        model = context.options.after(model, payload)

      if err
        if err instanceof mongoose.Error
          #moongoose error, probably validation
          herror = Hapi.error.badRequest err.toString()
          return request.reply herror
        else
          #mongo db itself is erroring
          herror = Hapi.error.internal err
          return request.reply herror

      socket.broadcast model.toJSON()
      return request.reply model.toJSON()
