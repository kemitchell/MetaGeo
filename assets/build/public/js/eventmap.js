/*
@module EventMap
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, ExclusivePanel, Panel, _ref, _ref1;
    Backbone = require("backbone");
    Panel = (function(_super) {
      __extends(Panel, _super);

      function Panel() {
        _ref = Panel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      /*
      opens a panel
      @method render
      */


      Panel.prototype.render = function() {
        return this.$el.addClass("panelOpen");
      };

      /*
      closes a panel
      @method close
      */


      Panel.prototype.close = function() {
        return this.$el.removeClass("panelOpen");
      };

      return Panel;

    })(Backbone.View);
    ExclusivePanel = (function(_super) {
      __extends(ExclusivePanel, _super);

      function ExclusivePanel() {
        _ref1 = ExclusivePanel.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      ExclusivePanel.prototype.render = function() {
        this.$el.removeClass('hidden');
        return $("#exclusivePanelWrapper").addClass("exclusivePanelOpen");
      };

      ExclusivePanel.prototype.close = function() {
        this.$("input").tooltip("destroy");
        this.$('form')[0].reset();
        return $("#exclusivePanelWrapper").removeClass("exclusivePanelOpen");
      };

      return ExclusivePanel;

    })(Backbone.View);
    return {
      Panel: Panel,
      ExclusivePanel: ExclusivePanel
    };
  });

}).call(this);
