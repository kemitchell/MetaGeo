mongoose = require 'mongoose'
subscriptionSchema = new mongoose.Schema
  client: String
  transports: []
  filter:
    near: []
    distance: Number
    actor:
      type: String
    geometry:
      type:
        type: String
      coordinates: []

subscriptionSchema.index {'filter.geometry': '2dsphere', 'filter.geometry': 'sparse'}
Subscription = mongoose.model('Subscription', subscriptionSchema)
module.exports = Subscription
