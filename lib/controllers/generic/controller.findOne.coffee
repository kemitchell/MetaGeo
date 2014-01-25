###
CRUD findOne
###
_ = require 'lodash'
Hapi = require 'hapi'

module.exports = (options) ->

  (request, reply) ->
    params = request.params

    #get the model
    Model = options.model
    if not Model.modelName?
      Model = Model params

    #find the model
    Model.findOne(params).exec (err, model)->
      if err
        return request.reply Hapi.error.internal err
      if not model
        return reply Hapi.error.notFound("model searched for by " + JSON.stringify(params) + " not found")
      return reply model
