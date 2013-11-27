###
CRUD find
###
_ = require 'lodash'
Hapi = require 'hapi'
socket = require '../../socket'

module.exports = (options) ->

  (request) ->
    params = _.merge request.query, request.params
    Model = options.model
    #if the model is not mongoose the run and hope that it gives us a mongoose model
    if not Model.modelName?
      Model = Model params
    
    if options.before
      options.before params

    limit = Number params.limit
    sort = params.sort or params.order or undefined
    skip = Number(params.skip or params.offset) or undefined

    #Build the query
    #Remove undefined params
    #(as well as limit, skip, and sort)
    where = _.transform params, (result, param, key)->
      if key not in ['limit', 'offset', 'skip', 'sort', 'sub'] and not options.queries?[key] and param
        if _.isObject param
          param = _.transform param, (result, prop, key)->
            result["$"+key] = prop

        result[key] = param

    #add queries 
    if options.queries
      for param, query of options.queries
        if params[param]
          where = _.merge(where, query(params[param], params))

    #add limit
    if options.maxLimit
      if _.isNaN(limit) or limit > options.maxLimit
        limit = options.maxLimit

    #add oder
    if options.defaultOrder and not sort
      sort = options.defaultOrder

    Model.find(where).sort(sort).skip(skip).limit(limit).exec (err, models) ->
      # An error occurred 
      if err
        return request.reply Hapi.error.internal err

      #Build set of model values
      modelValues = []
      models.forEach (model) ->
        modelValues.push model

      #subscirbe to this query
      if options.tailableModel and params.sub
        if not socket.subscribe params.sub, where, options.tailableModel
          return request.reply Hapi.error.badRequest 'invalid session id'

      #add wrapper
      if options.after
        #some of the params may have mutated
        params.sort = sort
        params.limit = limit
        params.skip = skip
        modelValues = options.after modelValues, 'find', params

      return request.reply modelValues
