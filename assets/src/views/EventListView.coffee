###
controls the event list view
@class EventListView
@construtor
@extends EventMap.PanelView
###

EventMap = require('../lib/emViews')
JST = require("../templates/tmp.js").JST
_ = require("underscore")

class EventList extends EventMap.Panel
  el: "#list"
  initialize: (options)->
    @model.on("add", @addEvent, @)
    #@model.nextPage()
    @$("#eventList").on("scroll", @onScroll)

  renderEvents: ()->
    for event in @model.models
      @addEvent(event)

  addEvent: (event)->
    @$("#eventList").append(JST['templates/runtime/eventLi'](event.toJSON()))

  onScroll: (e) =>
    # get more events 100 pixels from the top or bottom
    triggerPoint = 100
    el = @$("#eventList")[0]
    if el.scrollTop + el.clientHeight + triggerPoint > el.scrollHeight
      @model.ffetch()
    else if el.scrollTop < triggerPoint
      @model.rfetch()

module.exports = EventList
