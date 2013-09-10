(function() {
  define(function(require) {
    var Backbone, _;
    Backbone = require('backbone');
    _ = require('underscore');
    return Backbone.Model.extend({
      url: "/event",
      validation: {
        title: {
          required: true
        },
        startDate: {
          required: true
        },
        startTime: {
          required: true
        },
        endDate: {
          required: true
        },
        endTime: {
          required: true
        },
        content: {
          required: true
        },
        lat: {
          required: true,
          pattern: 'number'
        },
        lng: {
          required: true,
          pattern: 'number'
        }
      },
      blacklist: ['startTime', 'endTime', 'endDate', 'startDate'],
      toJSON: function(attrs, options) {
        return _.omit(this.attributes, this.blacklist);
      }
    });
  });

}).call(this);
