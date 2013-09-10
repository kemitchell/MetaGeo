###
CRUD find
###

module.exports = (context) ->
  _ = require('lodash')

  tryToParseJSON = (json)->
    if(not _.isString(json))
      return null
    try
      return JSON.parse(json)
    catch e
      return e

  (request) ->
    # Grab model class based on the controller this blueprint comes from
    # If no model exists, move on to the next middleware
    if context.globals?
      Model = context.globals
    else
      return request.reply("no model defined")
    
    params = _.merge request.params, request.query
    if params.id
      Model.findById(params.id).exec (err, model)->
        if err
          return request.reply(err)
        if not model
          return request.reply(Hapi.error.notFound("model with id of" + params.id + " not found"))

        return request.reply(model)
    else
      where = params.where
      limit = params.limit
      sort = params.sort or params.order

      if _.isString(where)
        where = tryToParseJSON(where)

      unless where
        # Remove undefined params
        # (as well as limit, skip, and sort)
        # to build a proper where query
        where = _.transform params, (result, param, key)->
          if key not in ['limit', 'offset', 'skip', 'sort'] and Model.schema[key] and param
            if _.isString(param)
              param = tryToParseJSON(param)
            result[key] = param

      #add limit
      if context?.options?.maxLimit?
        limit = Number(limit)
        if _.isNaN(limit) or limit > context.options.maxLimit
          limit = context.options.maxLimit
 
      #add oder
      if context?.options?.defaultOrder? and not sort
        sort = context.options.defaultOrder

      options =
        limit: Number(limit) or undefined
        skip: Number(params.skip or params.offset) or undefined
        sort: sort or undefined
        where: where or undefined

      #add the queury modifier
      if context?.options?.query?
        options = context.options.query options, request.query

      Model.find(options.where).sort(options.sort).skip(options.skip).limit(options.limit).exec (err, models) ->
        # An error occurred 
        if(err)
          return request.reply(err)

        #if sails.config.hooks.pubsub and not Model.silent
        #  Model.subscribe(req.socket)
        #  Model.subscribe(req.socket, models)

        #Build set of model values
        modelValues = []
        models.forEach (model) ->
          modelValues.push(model)

        #add wrapper
        if context?.options?.result?
          modelValues = context.options.result(modelValues, options)

        return request.reply(modelValues)
