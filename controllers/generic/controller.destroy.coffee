###
CRUD delete
###
_ = require('lodash')
Hapi = require('hapi')

module.exports = (options) ->
 
  (request) ->
    params = _.merge  request.query, request.params

    Model = options.model
    if not Model.modelName?
      Model = Model params

    Model.findOne(params).exec (err, model)->
      if err
        return request.reply Hapi.error.internal err
      if not model
        return request.reply Hapi.error.notFound("model deleted by " + JSON.stringify(params) + " not found")

      canDelete = if options.check then options.check(model, request) else true

      if canDelete
        #remove the doc
        model.remove ()->

          if options.tailableModel
            json = model.toJSON()
            json.action = 'delete'
            tailableModel = new options.tailableModel  json
            tailableModel.save()

          if options.after
            options.after model, 'delete', request

          return request.reply model
      else
        return request.reply Hapi.error.forbidden 'permission denied'
