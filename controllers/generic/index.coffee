module.exports = ->
  create: (options) ->
    return require("./controller.create.coffee")({parent: @, options: options or {}})

  find: (options) ->
    return require("./controller.find.coffee")({parent: @, options: options or {}})
    
  update: (options) ->
    return require("./controller.update.coffee")({parent: @, options: options or {}})

  delete: (options) ->
    return require("./controller.destroy.coffee")({parent: @, options: options or {}})
