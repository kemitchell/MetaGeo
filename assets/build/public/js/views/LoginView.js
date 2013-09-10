/*
the login view
@class LoginView
@construtor
@extends PanelView
*/


(function() {
  define(function(require) {
    var EventMap, utils;
    EventMap = require('../eventmap');
    utils = require('utils');
    return EventMap.ExclusivePanel.extend({
      el: "#login",
      initialize: function(options) {
        Backbone.Validation.bind(this);
        window.vent.on("close-login", this.close, this);
        return $("#logout").on("click", this.logout, this);
      },
      events: {
        "click #loginButton": 'submit'
      },
      submit: function(event) {
        var promise;
        event.preventDefault();
        this.model.set(utils.form2object("#loginForm"));
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
      }
    });
  });

}).call(this);
