###
this is a generic create controller
###

Hapi     = require 'hapi'
mongoose = require 'mongoose'
_        = require 'lodash'
subpub   = require '../../pubsub'

module.exports = (options) ->

  (request) ->

    payload = _.merge request.payload, request.params
    Model = options.model

    #get the model based of the params
    if not Model.modelName?
      Model = Model payload

    #field manipulation and validation
    fields =  options.fields
    if fields
      errors = {}
      for  index, field of fields
        if _.isFunction field
          val = field payload[index], payload, request
          if not _.isUndefined val
            payload[index] = val

        else
          if _.isFunction field.transform
            #get the value of the paramter being manuplated
            payload[index] = field.transform payload[index], payload, request

          #run validation
          if _.isFunction field.validate
            err = field.validate payload[index], payload, request
            if err
              errors[index] = err

      if not _.isEmpty(errors)
        herror = Hapi.error.badRequest {fields: errors}
        return request.reply herror

    #create a new model
    model = new Model payload
    #and save it
    model.save (err)->
      if err
        if err instanceof mongoose.Error
          fields = {}
          for key, error of err.errors
            fields[key] = key + ' is ' + error.type
          #moongoose error, probably validation
          herror = Hapi.error.badRequest
            fields: fields

          return request.reply herror
        else
          #mongo db itself is erroring
          herror = Hapi.error.internal err
          return request.reply herror
      else
        #run after function only if there is no errors
        if options.after
          options.after model, 'create', payload

        #push the model
        if options.pubsub
          subpub.pub model.toJSON(), 'create'

        return request.reply model.toJSON()
