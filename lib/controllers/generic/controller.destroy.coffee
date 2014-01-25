###
CRUD delete
###
_ = require('lodash')
Hapi = require('hapi')

module.exports = (options) ->
 
  (request, reply) ->
    params = _.merge  request.query, request.params

    Model = options.model
    if not Model.modelName?
      Model = Model params

    Model.findOne(params).exec (err, model)->
      if err
        return reply Hapi.error.internal err
      if not model
        return reply Hapi.error.notFound("model deleted by " + JSON.stringify(params) + " not found")

      canDelete = if options.check then options.check(model, request) else true

      if canDelete
        #remove the doc
        model.remove ()->
          if options.after
            options.after model, 'delete', request

          if options.pubsub
            request.server.plugins['metageo-pubsub'].pub model.toJSON(), 'delete'

          return reply model
      else
        return reply Hapi.error.forbidden 'permission denied'