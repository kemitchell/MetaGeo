define (require)->
  Backbone = require('backbone')
  $ = require('jquery')
  require("templates/tmp.js")

  Backbone.View.extend
    el: 'body'
    initialize: (options)->
      window.commands.setHandler("hidePanel", @hidePanel, this)
      @model.on('change', @render, @)
      @render()

    render: ()->
      @$("#userNav").html(JST['assets/templates/runtime/userNav'](@model.toJSON()))

    events:
      #transition events
      "webkitTransitionEnd #exclusivePanelWrapper": 'exclusiveTransEnd'
      "transitionend #exclusivePanelWrapper": 'exclusiveTransEnd'
      "oTransitionEnd #exclusivePanelWrapper": 'exclusiveTransEnd'
      "msTransitionEnd #exclusivePanelWrapper": 'exclusiveTransEnd'
      "webkitTransitionEnd #panelWrapper": 'panelTransEnd'
      "transitionend .panel": 'panelTransEnd'
      "oTransitionEnd .panel": 'panelTransEnd'
      "msTransitionEnd .panel": 'panelTransEnd'

    exclusiveTransEnd:()->
      #hide panel after the wrapper has closed
      if not $("#exclusivePanelWrapper").hasClass("exclusivePanelOpen")
        $(".exclusivePanel").addClass("hidden")

    showPanel: (event)->
      #get the select element
      if event.currentTarget?
        el = $(event.currentTarget).data("el")
      else
        el = event

      #close the current view
      if @currentView
        @currentView.close()

      #save the view so we can trigger a close event later
      @currentView = window.em.views[el]
      #and render it
      @currentView.render()

    hidePanel: ()->
      if @currentView
        @currentView.close()
        delete @currentView


    panelTransEnd:()->
      console.log("panel trans done")
