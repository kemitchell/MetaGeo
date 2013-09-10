define (require)->
  Backbone = require('backbone')
  L = require('leaflet')
  settings = require('settings')
  Backbone.View.extend
    initialize: (options)->
      #if the map has been cleared then don't push new events to it
      @cleared = false
      @model.on("add", @addEvent, @)
      window.commands.setHandler("clearMap", @clearMap, @)
      window.commands.setHandler("renderEventsOnMap", @renderEvents, @)
      window.commands.setHandler("addDraggableMarker", @addDraggableMarker, @)

    render: ()->
      @map = L.map('map', {zoomControl: false}).setView(settings.map.center, settings.map.zoom)
      L.tileLayer settings.map.tilesetUrl,
        attribution: settings.map.tilesetAttrib
        minZoom: settings.map.minZoom
        maxZoom: settings.map.maxZoom
      .addTo(@map)

      #create geoJSON layre
      @geoJsonLayer = L.geoJson().addTo(@map)

    renderEvents: ()->
      @cleared = false
      for event in @model.models
        @addEvent(event)

    addEvent: (event)->
      if not @cleared
        geo = event.get("geometry")
        @geoJsonLayer.addData(geo)

    addDraggableMarker: ()->
      marker = L.marker(settings.map.center, {draggable: true})
      popupContent = "Please drag the marker too where the event is"
      marker.on 'dragend', (event)->
        window.vent.trigger('dragend', event)
      @geoJsonLayer.addLayer(marker)
      marker.bindPopup(popupContent).openPopup()
      @map.panTo(settings.map.center)


    clearMap: ()->
      @cleared = true
      @geoJsonLayer.clearLayers()
