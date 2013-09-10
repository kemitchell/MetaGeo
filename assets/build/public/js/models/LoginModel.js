(function() {
  define(function(require) {
    var Backbone;
    Backbone = require('backbone');
    return Backbone.Model.extend({
      url: "/login",
      defaults: {
        authenticated: false
      },
      validation: {
        username: {
          required: true
        },
        password: {
          required: true
        }
      },
      isAuthenticated: function() {
        if (this.get("authenticated")) {
          return true;
        } else {
          return false;
        }
      }
    });
  });

}).call(this);
