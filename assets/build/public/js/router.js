(function() {
  define(function(require) {
    var Backbone, _;
    _ = require('underscore');
    Backbone = require('backbone');
    return Backbone.Router.extend({
      firstPage: true,
      routes: {
        "": "home",
        "list": "showPanel",
        "login": "showPanel",
        "logout": "logout",
        "register": "showPanel",
        "addEvent": "showPanel",
        "event/:id": "eventDetails"
      },
      loginRequired: ["addEvent"],
      before: function(prama, route) {
        if (_.contains(this.loginRequired, route) && !this.models.login.isAuthenticated()) {
          this.navigate("login", {
            trigger: true
          });
          return false;
        }
      },
      after: function(route) {
        return this.firstPage = false;
      },
      initialize: function(options) {
        this.views = options.em.views;
        return this.models = options.em.models;
      },
      home: function() {
        if (!this.firstPage) {
          return window.commands.execute("hidePanel");
        } else {
          return window.router.navigate("/list", {
            trigger: true
          });
        }
      },
      logout: function() {
        this.models.login.destroy();
        return this.models.login.clear();
      },
      showExclusivePanel: function() {
        var route;
        route = Backbone.history.fragment;
        return this.views.nav.showExclusivePanel(route);
      },
      showPanel: function() {
        var route;
        route = Backbone.history.fragment;
        return this.views.nav.showPanel(route);
      },
      eventDetails: function(id) {
        return console.log("details " + id);
      }
    });
  });

}).call(this);
