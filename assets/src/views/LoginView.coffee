###
the login view
@class LoginView
@construtor
@extends PanelView
###

EventMap = require('../lib/emViews')
utils = require('../lib/utils')

module.exports = EventMap.ExclusivePanel.extend
  el: "#login"
  initialize: (options)->
    Backbone.Validation.bind @
    window.vent.on "close-login", @close, @
    $("#logout").on "click", @logout, @

  events:
    "click #loginButton": 'submit'

  submit: (event)->
    event.preventDefault()
    @model.set(utils.form2object("#loginForm"))
    if @model.isValid(true)
      promise = @model.save()
      promise.error (response)->
        json = JSON.parse(response.responseText)
        console.log(json)
       
      promise.success (response)->
        window.router.navigate("/", {trigger: true})
