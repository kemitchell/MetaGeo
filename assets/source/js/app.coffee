# Require.js allows us to configure shortcut alias
# global require
require.config
  paths:
    "backbone": "../../bower_components/backbone/backbone"
    "backbone.paginator": "../../bower_components/backbone.paginator/lib/backbone.paginator"
    "backbone.wreqr": "../../bower_components/backbone.wreqr/lib/amd/backbone.wreqr"
    "backbone.validation": "../../bower_components/backbone-validation/dist/backbone-validation-amd"
    "backbone.routefilter": "../../bower_components/backbone.routefilter/dist/backbone.routefilter"
    "jquery": "../../bower_components/jquery/jquery"
    "jquery.tooltip": '../../bootstrap/js/bootstrap'
    "leaflet": "../../bower_components/leaflet/dist/leaflet-src"
    "require": "../../bower_components/require"
    "underscore": "../../bower_components/underscore/underscore"
    "socketjs-client": "../../bower_components/sockjs-client/sockjs.min"
    "jade-runtime": "../../bower_components/jade/runtime"
    "cs": "../../bower_components/require-cs/cs"
    "coffee-script": "../../bower_components/coffee-script/index"

  shim:
    'underscore':
      exports: '_'
    'backbone':
      # These script dependencies should be loaded before loading
      # backbone.js
      deps: ['underscore', 'jquery'],
      # Once loaded, use the global 'Backbone' as the
      # module value.
      exports: 'Backbone'
    'backbone.paginator': ['backbone']
    'backbone.routefilter': ['backbone']
    'leaflet':
      exports: 'L'
    'jquery.tooltip':
      deps: ['jquery']

define (require) ->
  
  $ = require('jquery')
  require('jquery.tooltip')
  Backbones = require('backbone')
  _ = require('underscore')
  require('backbone.wreqr')
  require('backbone.validation')
  require('backbone.routefilter')
  #make jade global for JST
  window.jade = require('jade-runtime')
  #start sockets
  require('socketAdapter')

  Router = require('router')
  #include views
  MapView = require('cs!views/MapView')
  NavView = require('cs!views/NavView')
  LoginView = require('cs!views/LoginView')
  RegisterView = require('cs!views/RegisterView')
  AddEventView = require('cs!views/AddEventView')
  EventListView = require('cs!views/EventListView')

  #include models
  LoginModel = require('cs!models/LoginModel')
  UserModel = require('cs!models/UserModel')
  EventModel = require('cs!models/EventModel')
  EventCollection = require('cs!collections/EventCollection')

  #create global refrances
  window.vent = new Backbone.Wreqr.EventAggregator()
  window.commands = new Backbone.Wreqr.Commands()

  #modify Backbone Validation to display tooltips
  _.extend Backbone.Validation.callbacks,{
      valid: (view, attr, selector)->
        el = view.$('[' + selector + '=' + attr + ']')
        el.tooltip('destroy')

      invalid: (view, attr, error, selector)->

        el = view.$('[' + selector + '=' + attr + ']')
        el.tooltip({trigger: "manual", title: error, container: "body"})
        el.tooltip('show')
    }
   

  #create a global event map
  em = window.em = {}
  em.views = {}
  em.collections = {}
  em.models = {}

  em.models.login = new LoginModel
  #create an empty user model for new users
  em.models.user = new UserModel

  em.collections.events = new EventCollection

  em.views.map = new MapView
    model: em.collections.events

  em.views.list = new EventListView
    model: em.collections.events

  #fetch some events After the MapView
  em.collections.events.pager()
  #init some views
  em.views.nav = new NavView
    model: em.models.login

  em.views.login = new LoginView
    model: em.models.login

  em.views.register = new RegisterView
    model: em.models.user

  em.views.addEvent = new AddEventView
    model: new EventModel

  #get login status
  em.models.login.fetch success: ()->
    #start backbone
    window.router = new Router({em: em})
    Backbone.history.start()

  #kick off the map
  em.views.map.render()
