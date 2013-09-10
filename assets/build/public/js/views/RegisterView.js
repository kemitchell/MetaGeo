/*
the register view. Where you can register an account.
@class RegisterView
@construtor
@extends PanelView
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var EventMap, utils, _ref;
    EventMap = require('../eventmap');
    utils = require('utils');
    return (function(_super) {
      __extends(_Class, _super);

      function _Class() {
        _ref = _Class.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      _Class.prototype.el = "#register";

      _Class.prototype.events = {
        "click #registerButton": "submit",
        'blur input': 'updateModel'
      };

      _Class.prototype.initialize = function(options) {
        Backbone.Validation.bind(this);
        return window.vent.on("close-register", this.close, this);
      };

      _Class.prototype.updateModel = function(el) {
        var $el;
        $el = $(el.target);
        return this.model.set($el.attr('name'), $el.val(), {
          validate: true
        });
      };

      _Class.prototype.submit = function(event) {
        var promise;
        event.preventDefault();
        if (this.model.isValid(true)) {
          promise = this.model.save();
          promise.error(function(response) {
            var json;
            json = JSON.parse(response.responseText);
            return console.log(json);
          });
          return promise.success(function(response) {
            return window.router.navigate("/", {
              trigger: true
            });
          });
        }
      };

      return _Class;

    })(EventMap.ExclusivePanel);
  });

}).call(this);
