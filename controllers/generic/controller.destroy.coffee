###
CRUD delete
###

module.exports = (context) ->
  _ = require('lodash')
 
  (req,res,next) ->
    params = _.merge req.params, req.query, req.body
    if not params.id
      return res.send 400, 'Bad Request: No id provided.'

    # Grab model class based on the controller this blueprint comes from 
    # If no model exists, move on to the next middleware
    if context.globals
      Model = context.globals
    else
      return res.send 400, 'Bad Request: No Model provided.'
    
    # Otherwise, find and destroy the model in question

    if context.options?.check? and _.isFunction(context.options.check)
      if not context.options.check req, params
        return res.send 401, 'Not Allowed'

    Model.findByIdAndRemove params.id, (err, result) ->
      if err
        return res.send 500, err

      # Respond with model which was destoryed
      if result
        return res.send result

      return res.send 404, "model not found"
