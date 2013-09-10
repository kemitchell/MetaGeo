/*
controls the event list view
@class EventListView
@construtor
@extends EventMap.PanelView
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var EventMap, _ref;
    EventMap = require('../eventmap');
    require("templates/tmp.js");
    return (function(_super) {
      __extends(_Class, _super);

      function _Class() {
        _ref = _Class.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      _Class.prototype.el = "#list";

      _Class.prototype.initialize = function(options) {
        this.cleared = false;
        return this.model.on("add", this.addEvent, this);
      };

      _Class.prototype.renderEvents = function() {
        var event, _i, _len, _ref1, _results;
        _ref1 = this.model.models;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          event = _ref1[_i];
          _results.push(this.addEvent(event));
        }
        return _results;
      };

      _Class.prototype.addEvent = function(event) {
        return this.$("#eventList").append(JST['assets/templates/runtime/eventLi'](event.toJSON()));
      };

      return _Class;

    })(EventMap.Panel);
  });

}).call(this);
