Backbone = require('backbone')
EventModel = require('../models/EventModel')

class Events extends Backbone.Collection
  model: EventModel
  url: '/events/'
  limit: 30

  forward:
    more: true
    loading: false
    offset: 0
    query: "startDateTime[gt]"

  reverse:
    more: true
    loading: false
    offset: 0
    query: "startDateTime[lt]"

  startDate: new Date()

  initialize: ()->
    window.vent.on 'eventAdd', (event) =>
      @add(event)

  parse: (response)->
    response.items

  ffetch: ()->
    @_fetch("forward")

  rfetch: ()->
    @_fetch("reverse")

  _fetch: (direction)->
    if dir is "forward"
      dir = @forward
    else
      dir = @reverse

    if dir.more and not dir.loading
      dir.loading = true
      data =
        offset: dir.offset
        limit: @limit
      
      data[dir.query] = @startDate.toJSON()

      @fetch(
        success: (events, request)->
          dir.more = request.pages.more
          dir.loading = false
        data: data

      )

module.exports =  Events
