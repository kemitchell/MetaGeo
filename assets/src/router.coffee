_ = require('underscore')
Backbone = require('backbone')

module.exports = Backbone.Router.extend
  firstPage: true
  routes:
    "": "home"
    "list": "showPanel"
    "login": "showPanel"
    "logout": "logout"
    "register": "showPanel"
    "addEvent": "showPanel"
    "event/:id": "eventDetails"

  #views that are protected by a login screen
  loginRequired: ["addEvent"]

  #checks before each route
  before: (prama, route)->
    if _.contains(@loginRequired, route) and not @models.login.isAuthenticated()
      @navigate "login", {trigger: true}
      return false

  after: (route)->
    @firstPage = false

  initialize: (options)->
    @views = options.em.views
    @models = options.em.models


  home: ()->
    if not @firstPage
      window.commands.execute("hidePanel")
    else
      window.router.navigate("/list", {trigger: true})

  logout: ()->
    @models.login.destroy()
    @models.login.clear()

  showExclusivePanel: ()->
    #get the current route
    route = Backbone.history.fragment

    #require ["views/" + route + "View"], (CurrentView)->
    @views.nav.showExclusivePanel(route)

  showPanel: ()->
    #get the current route
    route = Backbone.history.fragment

    #require ["views/" + route + "View"], (CurrentView)->
    @views.nav.showPanel(route)
  
  eventDetails: (id)->
    #if this.views.details
    console.log("details " + id)
