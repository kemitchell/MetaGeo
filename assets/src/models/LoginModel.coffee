Backbone = require('backbone')

module.exports = Backbone.Model.extend
  url: "/login"
  defaults:
    authenticated: false

  validation:
    username:
      required: true
    password:
      required: true

  isAuthenticated: ()->
    if @get("authenticated")
      return true
    else
      return false
