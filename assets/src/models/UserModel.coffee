Backbone = require('backbone')

module.exports = Backbone.Model.extend
  url: "/user"

  validation:
    username:
      required: true
    email:
      required: true
      pattern: 'email'
    password:
      required: true
    passwordRepeat:
      equalTo: 'password'
