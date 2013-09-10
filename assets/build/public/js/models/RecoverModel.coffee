define (require)->
  Backbone = require('backbone')

  Backbone.Model.extend
    url: "/recover"
