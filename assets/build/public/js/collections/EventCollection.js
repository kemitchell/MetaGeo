(function() {
  define(function(require) {
    var Backbone, EventModel, PaginatedCollection;
    Backbone = require('backbone');
    require('backbone.paginator');
    require('backbone.wreqr');
    EventModel = require('models/EventModel');
    return PaginatedCollection = Backbone.Paginator.requestPager.extend({
      model: EventModel,
      paginator_core: {
        type: 'GET',
        dataType: 'json',
        url: '/events/?'
      },
      paginator_ui: {
        firstPage: 0,
        currentPge: 0,
        perPage: 3,
        totalPages: 10,
        start_date: (new Date()).toISOString()
      },
      initialize: function() {
        var _this = this;
        return window.vent.on('eventAdd', function(event) {
          return _this.add(event);
        });
      },
      server_api: {
        limit: function() {
          return this.perPage;
        },
        start: function() {
          return this.start_date;
        }
      },
      parse: function(response) {
        return response.items;
      }
    });
  });

}).call(this);
