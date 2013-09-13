###
controls the event list view
@class EventListView
@construtor
@extends EventMap.PanelView
###

define (require)->
  EventMap = require('../eventmap')
  require("templates/tmp.js")

  class extends EventMap.Panel
    el: "#list"
    initialize: (options)->
      #if the map has been cleared then don't push new events to it
      @cleared = false
      @model.on("add", @addEvent, @)

    renderEvents: ()->
      for event in @model.models
        @addEvent(event)

    addEvent: (event)->
      @$("#eventList").append(JST['source/templates/runtime/eventLi'](event.toJSON()))
