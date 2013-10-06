###
CRUD find
###
_ = require 'lodash'
Hapi = require 'hapi'

module.exports = (context) ->

  tryToParseJSON = (json)->
    try
      return JSON.parse json
    catch e
      return json

  (request) ->
    params = _.merge request.query, request.payload, request.params

    Model = context.options.getModel or context.options.model or context.parent.getModel or context.parent.model
    if not Model.modelName?
      Model = Model params
    
    if context?.options?.before?
      context.options.before params

    if params.id
      Model.findById(params.id).exec (err, model)->
        if err
          return request.reply Hapi.error.internal err
        if not model
          return request.reply Hapi.error.notFound Model.modelName + " with id of" + params.id + " not found"

        return request.reply model
    else
      limit = Number params.limit
      sort = Number(params.sort or params.order) or undefined
      skip = Number(params.skip or params.offset) or undefined

      #Build the query
      #Remove undefined params
      #(as well as limit, skip, and sort)
      where = _.transform params, (result, param, key)->
        if key not in ['limit', 'offset', 'skip', 'sort'] and not context.options.queries[key] and param
          if _.isString param
            param = tryToParseJSON param

          if _.isObject param
            param = _.transform param, (result, prop, key)->
              result["$"+key] = prop

          result[key] = param

      #add queries 
      if context?.options?.queries?
        for param, query of context.options.queries
          if params[param]
            Model = query params[param], Model, params

      #add limit
      if context?.options?.maxLimit?
        if _.isNaN(limit) or limit > context.options.maxLimit
          limit = context.options.maxLimit
 
      #add oder
      if context?.options?.defaultOrder? and not sort
        sort = context.options.defaultOrder

      Model.find(where).sort(sort).skip(skip).limit(limit).exec (err, models) ->
        # An error occurred 
        if err
          return request.reply Hapi.error.internal err

        #Build set of model values
        modelValues = []
        models.forEach (model) ->
          modelValues.push model

        #add wrapper
        if context?.options?.after?
          #some of the params may have mutated
          params.sort = sort
          params.limit = limit
          params.skip = skip
          modelValues = context.options.after modelValues, params

        return request.reply modelValues
