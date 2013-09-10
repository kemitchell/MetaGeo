define (require)->

  Backbone = require('backbone')
  require('backbone.paginator')
  require('backbone.wreqr')
  EventModel = require('models/EventModel')

  PaginatedCollection = Backbone.Paginator.requestPager.extend
    model: EventModel
    paginator_core:
      type: 'GET'
      dataType: 'json'
      url: '/events/?'

    paginator_ui:
      firstPage: 0
      currentPge: 0
      perPage: 3
      totalPages: 10
      start_date: (new Date()).toISOString()


    initialize: ()->
      window.vent.on 'eventAdd', (event) =>
        @add(event)

    server_api:
      limit: ()->
        @perPage
      start: ()->
        @start_date
        
      #the query field in the request

    parse: (response)->
      response.items
      #this.totalPages = Math.ceil(response.d.__count / this.perPage)
      #return tags
