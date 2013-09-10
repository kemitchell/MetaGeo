###
add an event view!
@class AddEventView
@construtor
@extends EventMap.Panel
###

define (require)->
  EventMap = require('../eventmap')
  utils = require('utils')

  class extends EventMap.Panel
    el: "#addEvent"
    events:
      "click #addEventButton": "submit"
      'blur input': 'updateModel'
      'blur textarea': 'updateModel'

    initialize: (options)->
      Backbone.Validation.bind @
      window.vent.on "dragend", @dragend, @

    render:()->
      window.commands.execute "clearMap"
      window.commands.execute "addDraggableMarker"
      super()
      
    close:()->
      window.commands.execute "clearMap"
      window.commands.execute "renderEventsOnMap"
      @$("input, textarea").tooltip "destroy"
      #Reset the form
      @$('form')[0].reset()
      #Clear the model
      @model.clear()
      super()

    updateModel: (el)->
      $el = $(el.target)
      @model.set($el.attr('name'), $el.val(), {validate : true})
    
    #set the lat, lng value when the maker is dragged
    dragend: (event)->
      latlng = event.target.getLatLng()
      @model.set('lat', latlng.lat)
      @model.set('lng', latlng.lng)

    submit: (event)->
      event.preventDefault()
      if @model.isValid(true)
        promise = @model.save()
        promise.error (response)->
          json = JSON.parse(response.responseText)
          console.log(json)
         
        promise.success (response)->
          window.router.navigate("/", {trigger: true})
