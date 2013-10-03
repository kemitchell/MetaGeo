module.exports =
  class Generic
    constructor: (globals) ->
      Generic.globals = globals

    @create: (options) ->
      return require("./controller.create.coffee")({parent: @, options: options})

    @find: (options) ->
      return require("./controller.find.coffee")({parent: @, options: options})
      
    @update: (options) ->
      return require("./controller.update.coffee")({parent: @, options: options})
 
    @delete: (options) ->
      return require("./controller.destroy.coffee")({parent: @, options: options})
