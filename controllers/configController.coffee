config = require("../config")
module.exports = (request)->
  @reply(config.api)
