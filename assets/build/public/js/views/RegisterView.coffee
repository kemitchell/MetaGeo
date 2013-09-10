###
the register view. Where you can register an account.
@class RegisterView
@construtor
@extends PanelView
###

define (require)->
  EventMap = require('../eventmap')
  utils = require('utils')

  class extends EventMap.ExclusivePanel
    el: "#register"
    events:
      "click #registerButton": "submit"
      'blur input': 'updateModel'

    initialize: (options)->
      Backbone.Validation.bind @
      window.vent.on "close-register", @close, @

    updateModel: (el)->
      $el = $(el.target)
      @model.set($el.attr('name'), $el.val(), {validate : true})

    submit: (event)->
      event.preventDefault()
      if @model.isValid(true)
        promise = @model.save()
        promise.error (response)->
          json = JSON.parse(response.responseText)
          console.log(json)
         
        promise.success (response)->
          window.router.navigate("/", {trigger: true})
