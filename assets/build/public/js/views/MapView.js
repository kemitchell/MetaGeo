(function() {
  define(function(require) {
    var Backbone, L, settings;
    Backbone = require('backbone');
    L = require('leaflet');
    settings = require('settings');
    return Backbone.View.extend({
      initialize: function(options) {
        this.cleared = false;
        this.model.on("add", this.addEvent, this);
        window.commands.setHandler("clearMap", this.clearMap, this);
        window.commands.setHandler("renderEventsOnMap", this.renderEvents, this);
        return window.commands.setHandler("addDraggableMarker", this.addDraggableMarker, this);
      },
      render: function() {
        this.map = L.map('map', {
          zoomControl: false
        }).setView(settings.map.center, settings.map.zoom);
        L.tileLayer(settings.map.tilesetUrl, {
          attribution: settings.map.tilesetAttrib,
          minZoom: settings.map.minZoom,
          maxZoom: settings.map.maxZoom
        }).addTo(this.map);
        return this.geoJsonLayer = L.geoJson().addTo(this.map);
      },
      renderEvents: function() {
        var event, _i, _len, _ref, _results;
        this.cleared = false;
        _ref = this.model.models;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          event = _ref[_i];
          _results.push(this.addEvent(event));
        }
        return _results;
      },
      addEvent: function(event) {
        var geo;
        if (!this.cleared) {
          geo = event.get("geometry");
          return this.geoJsonLayer.addData(geo);
        }
      },
      addDraggableMarker: function() {
        var marker, popupContent;
        marker = L.marker(settings.map.center, {
          draggable: true
        });
        popupContent = "Please drag the marker too where the event is";
        marker.on('dragend', function(event) {
          return window.vent.trigger('dragend', event);
        });
        this.geoJsonLayer.addLayer(marker);
        marker.bindPopup(popupContent).openPopup();
        return this.map.panTo(settings.map.center);
      },
      clearMap: function() {
        this.cleared = true;
        return this.geoJsonLayer.clearLayers();
      }
    });
  });

}).call(this);
