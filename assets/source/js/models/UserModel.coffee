define (require)->
  Backbone = require('backbone')

  Backbone.Model.extend
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
