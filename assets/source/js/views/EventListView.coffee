###
controls the event list view
@class EventListView
@construtor
@extends EventMap.PanelView
###

define (require)->
  EventMap = require('../eventmap')
  require("templates/tmp.js")
  _ = require("underscore")

  class extends EventMap.Panel
    el: "#list"
    initialize: (options)->
      @model.on("add", @addEvent, @)
      @model.nextPage()
      @$("#eventList").on("scroll", @onScroll)

    renderEvents: ()->
      for event in @model.models
        @addEvent(event)

    addEvent: (event)->
      @$("#eventList").append(JST['source/templates/runtime/eventLi'](event.toJSON()))

    onScroll: (e) =>
      # get more events 100 pixels from the top or bottom
      triggerPoint = 100
      el = @$("#eventList")[0]
      if el.scrollTop + el.clientHeight + triggerPoint > el.scrollHeight
        @model.nextPage()
      else if el.scrollTop < triggerPoint
        @model.prevPage()
