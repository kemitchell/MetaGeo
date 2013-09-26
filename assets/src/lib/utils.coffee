_ = require('underscore')
Backbone = require('backbone')

#
#         * Form 2 Object: takes a select of a form and returns the contents
#         * of the form in an object
#         
form2object = (selector) ->
  result = {}
  formArray = $(selector).serializeArray()
  _.each formArray, (element) ->
    result[element.name] = element.value  unless element.value is "csrfmiddlewaretoken"
  return result

module.exports =
  form2object: form2object
