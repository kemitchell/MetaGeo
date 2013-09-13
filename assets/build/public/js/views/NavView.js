(function() {
  define(function(require) {
    var $, Backbone;
    Backbone = require('backbone');
    $ = require('jquery');
    require("templates/tmp.js");
    return Backbone.View.extend({
      el: 'body',
      initialize: function(options) {
        window.commands.setHandler("hidePanel", this.hidePanel, this);
        this.model.on('change', this.render, this);
        return this.render();
      },
      render: function() {
        return this.$("#userNav").html(JST['source/templates/runtime/userNav'](this.model.toJSON()));
      },
      events: {
        "webkitTransitionEnd #exclusivePanelWrapper": 'exclusiveTransEnd',
        "transitionend #exclusivePanelWrapper": 'exclusiveTransEnd',
        "oTransitionEnd #exclusivePanelWrapper": 'exclusiveTransEnd',
        "msTransitionEnd #exclusivePanelWrapper": 'exclusiveTransEnd',
        "webkitTransitionEnd #panelWrapper": 'panelTransEnd',
        "transitionend .panel": 'panelTransEnd',
        "oTransitionEnd .panel": 'panelTransEnd',
        "msTransitionEnd .panel": 'panelTransEnd'
      },
      exclusiveTransEnd: function() {
        if (!$("#exclusivePanelWrapper").hasClass("exclusivePanelOpen")) {
          return $(".exclusivePanel").addClass("hidden");
        }
      },
      showPanel: function(event) {
        var el;
        if (event.currentTarget != null) {
          el = $(event.currentTarget).data("el");
        } else {
          el = event;
        }
        if (this.currentView) {
          this.currentView.close();
        }
        this.currentView = window.em.views[el];
        return this.currentView.render();
      },
      hidePanel: function() {
        if (this.currentView) {
          this.currentView.close();
          return delete this.currentView;
        }
      },
      panelTransEnd: function() {
        return console.log("panel trans done");
      }
    });
  });

}).call(this);
