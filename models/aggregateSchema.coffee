###
  :: Collection
  -> model
###

mongoose = require 'mongoose'
Schema = mongoose.Schema

AggregateSchema = Schema {
  title:
    type: String
    required: true
  slug:
    type: String
  description:
    type: String
  aggregateEmail:
    type: String
    unique: true
    sparse: true
  subscriptions: [{aggregateId:Schema.Types.ObjectId, name:String, filter:String}]

},collection: 'Aggregates', discriminatorKey: 'objectType'

module.exports = AggregateSchema
