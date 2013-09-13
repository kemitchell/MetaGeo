(function() {
  require.config({
    paths: {
      "backbone": "../../bower_components/backbone/backbone",
      "backbone.paginator": "../../bower_components/backbone.paginator/lib/backbone.paginator",
      "backbone.wreqr": "../../bower_components/backbone.wreqr/lib/amd/backbone.wreqr",
      "backbone.validation": "../../bower_components/backbone-validation/dist/backbone-validation-amd",
      "backbone.routefilter": "../../bower_components/backbone.routefilter/dist/backbone.routefilter",
      "jquery": "../../bower_components/jquery/jquery",
      "jquery.tooltip": '../../bootstrap/js/bootstrap',
      "leaflet": "../../bower_components/leaflet/dist/leaflet-src",
      "require": "../../bower_components/require",
      "underscore": "../../bower_components/underscore/underscore",
      "socketjs-client": "../../bower_components/sockjs-client/sockjs.min",
      "jade-runtime": "../../bower_components/jade/runtime",
      "cs": "../../bower_components/require-cs/cs",
      "coffee-script": "../../bower_components/coffee-script/index"
    },
    shim: {
      'underscore': {
        exports: '_'
      },
      'backbone': {
        deps: ['underscore', 'jquery'],
        exports: 'Backbone'
      },
      'backbone.paginator': ['backbone'],
      'backbone.routefilter': ['backbone'],
      'leaflet': {
        exports: 'L'
      },
      'jquery.tooltip': {
        deps: ['jquery']
      }
    }
  });

  define(function(require) {
    var $, AddEventView, Backbones, EventCollection, EventListView, EventModel, LoginModel, LoginView, MapView, NavView, RegisterView, Router, UserModel, em, _;
    $ = require('jquery');
    require('jquery.tooltip');
    Backbones = require('backbone');
    _ = require('underscore');
    require('backbone.wreqr');
    require('backbone.validation');
    require('backbone.routefilter');
    window.jade = require('jade-runtime');
    require('socketAdapter');
    Router = require('router');
    MapView = require('cs!views/MapView');
    NavView = require('cs!views/NavView');
    LoginView = require('cs!views/LoginView');
    RegisterView = require('cs!views/RegisterView');
    AddEventView = require('cs!views/AddEventView');
    EventListView = require('cs!views/EventListView');
    LoginModel = require('cs!models/LoginModel');
    UserModel = require('cs!models/UserModel');
    EventModel = require('cs!models/EventModel');
    EventCollection = require('cs!collections/EventCollection');
    window.vent = new Backbone.Wreqr.EventAggregator();
    window.commands = new Backbone.Wreqr.Commands();
    _.extend(Backbone.Validation.callbacks, {
      valid: function(view, attr, selector) {
        var el;
        el = view.$('[' + selector + '=' + attr + ']');
        return el.tooltip('destroy');
      },
      invalid: function(view, attr, error, selector) {
        var el;
        el = view.$('[' + selector + '=' + attr + ']');
        el.tooltip({
          trigger: "manual",
          title: error,
          container: "body"
        });
        return el.tooltip('show');
      }
    });
    em = window.em = {};
    em.views = {};
    em.collections = {};
    em.models = {};
    em.models.login = new LoginModel;
    em.models.user = new UserModel;
    em.collections.events = new EventCollection;
    em.views.map = new MapView({
      model: em.collections.events
    });
    em.views.list = new EventListView({
      model: em.collections.events
    });
    em.collections.events.pager();
    em.views.nav = new NavView({
      model: em.models.login
    });
    em.views.login = new LoginView({
      model: em.models.login
    });
    em.views.register = new RegisterView({
      model: em.models.user
    });
    em.views.addEvent = new AddEventView({
      model: new EventModel
    });
    em.models.login.fetch({
      success: function() {
        window.router = new Router({
          em: em
        });
        return Backbone.history.start();
      }
    });
    return em.views.map.render();
  });

}).call(this);
