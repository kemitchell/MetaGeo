###
CRUD update
###
Hapi = require 'hapi'
_ = require 'lodash'

module.exports = (options) ->
  (request) ->

    params = request.params
    payload = request.payload

    if options.before
      options.before params

    if options.omit
      payload = _.omit payload, options.omit

    Model = options.model
    if not Model.modelName
      Model = Model params

    #field manipulation and validation
    fields =  options.fields
    if fields
      errors = {}
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

          #run validation but only if it exists in the payload
          if payload[index] and  _.isFunction field.validate
            err = field.validate payload[index], payload, request
            if err
              herror = Hapi.error.badRequest err
              return request.reply herror

      if not _.isEmpty(errors)
        herror = Hapi.error.badRequest {fields: errors}
        return request.reply herror

    #find the event
    Model.findOne(params).exec (err, model)->
      if err
        return request.reply Hapi.error.internal err
      if not model
        return request.reply Hapi.error.notFound(Model.modelName + " with id of" + params.id + " not found")

      canUpdate = if options.check then options.check(model, request) else true

      if canUpdate
        #update the doc
        model.set payload
        model.save ()->

          if options.tailableModel
            json = model.toJSON()
            json.action = 'update'
            tailableModel = new options.tailableModel  json
            tailableModel.save()

          if options.after
            options.after model, 'update', request

          return request.reply model
      else
        return request.reply Hapi.error.forbidden 'permission denied'
