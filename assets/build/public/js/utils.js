(function() {
  define(function(require) {
    var Backbone, form2object, _;
    _ = require('underscore');
    Backbone = require('backbone');
    form2object = function(selector) {
      var formArray, result;
      result = {};
      formArray = $(selector).serializeArray();
      _.each(formArray, function(element) {
        if (element.value !== "csrfmiddlewaretoken") {
          return result[element.name] = element.value;
        }
      });
      return result;
    };
    return {
      form2object: form2object
    };
  });

}).call(this);
