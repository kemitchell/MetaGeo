module.exports =
  class Generic
    constructor: (globals) ->
      Generic.globals = globals

    @create: (options) ->
      return require("./controller.create.coffee")({globals: @globals, options: options})

    @find: (options) ->
      return require("./controller.find.coffee")({globals: @globals, options: options})
      
    @update: (options) ->
      return require("./controller.update.coffee")({globals: @globals, options: options})
 
    @delete: (options) ->
      return require("./controller.destroy.coffee")({globals: @globals, options: options})
