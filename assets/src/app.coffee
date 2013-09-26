$ = require('../bower_components/jquery/jquery')
#use bootstrap tooltip
require('../bootstrap/js/bootstrap')
Backbone = require('backbone')
Backbone.$ = $
window.Backbone = Backbone
_ = require('underscore')
window._ = _
require("backbone.wreqr")
require("backbone-validation")
require("backbone.routefilter")
#make jade global for JST
window.jade = require("../node_modules/jade/runtime")
#start sockets
require('./socketAdapter')

Router = require('./router')
#include views
MapView = require('./views/MapView')
NavView = require('./views/NavView')
LoginView = require('./views/LoginView')
RegisterView = require('./views/RegisterView')
AddEventView = require('./views/AddEventView')
EventListView = require('./views/EventListView')

#include models
LoginModel = require('./models/LoginModel')
UserModel = require('./models/UserModel')
EventModel = require('./models/EventModel')
EventCollection = require('./collections/EventCollection')

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

window.onload = ()->

  em.views.map = new MapView
    model: em.collections.events

  #kick off the map
  em.views.map.render()

  em.views.list = new EventListView
    model: em.collections.events

  #init some views
  em.views.nav = new NavView
    model: em.models.login

  em.views.login = new LoginView
    model: em.models.login

  em.views.register = new RegisterView
    model: em.models.user

  em.views.addEvent = new AddEventView
    model: new EventModel

#fetch some events After the MapView
em.collections.events.ffetch()
em.collections.events.rfetch()

#get login status
em.models.login.fetch success: ()->
  #start backbone
  window.router = new Router({em: em})
  Backbone.history.start()

