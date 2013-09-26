Backbone = require('backbone')
_ = require('underscore')

module.exports = Backbone.Model.extend
  url: "/event"
  #initialize: ()->
  validation:
    title:
      required: true

    startDate:
      required: true

    startTime:
      required: true

    endDate:
      required: true

    endTime:
      required: true

    content:
      required: true

    lat:
      required: true
      pattern: 'number'

    lng:
      required: true
      pattern: 'number'

  blacklist: ['startTime', 'endTime', 'endDate', 'startDate']

  toJSON: (attrs, options)->
    return _.omit this.attributes, this.blacklist
