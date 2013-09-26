###
@module EventMap
###
Backbone = require "backbone"

class Panel extends Backbone.View
  ###
  opens a panel
  @method render
  ###
  render: ->
    @$el.addClass("panelOpen")

  ###
  closes a panel
  @method close
  ###
  close: ->
    @$el.removeClass("panelOpen")
    

class ExclusivePanel extends Backbone.View
  render: ()->
    @$el.removeClass('hidden')
    #slide in
    $("#exclusivePanelWrapper").addClass("exclusivePanelOpen")

  close: ()->
    @$("input").tooltip "destroy"
    #Reset the form
    @$('form')[0].reset()
    #hide el
    $("#exclusivePanelWrapper").removeClass("exclusivePanelOpen")
   
module.exports =
  Panel: Panel
  ExclusivePanel: ExclusivePanel
