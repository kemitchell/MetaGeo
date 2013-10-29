###
  :: Collection
  -> model
###

mongoose = require 'mongoose'
Schema = mongoose.Schema

AggregateSchema = Schema {
  description:
    type: String
  aggregateEmail:
    type: String
    unique: true
    sparse: true
  slug:
    type: String
  subscriptions: [{aggregateId:Schema.Types.ObjectId, name:String, filter:String}]

},collection: 'Aggregates', discriminatorKey: 'objectType'

module.exports = mongoose.model 'Aggregate', AggregateSchema

###
ListSchema.pre 'validate', (next)->
  collection = this
  if !collection.isModified 'slug'
    return next()
  collection.email = collection.slug+'@mapkido.com'
  return next()
###
