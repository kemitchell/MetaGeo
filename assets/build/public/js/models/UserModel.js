(function() {
  define(function(require) {
    var Backbone;
    Backbone = require('backbone');
    return Backbone.Model.extend({
      url: "/user",
      validation: {
        username: {
          required: true
        },
        email: {
          required: true,
          pattern: 'email'
        },
        password: {
          required: true
        },
        passwordRepeat: {
          equalTo: 'password'
        }
      }
    });
  });

}).call(this);
