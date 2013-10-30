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
},collection: 'aggregates', discriminatorKey: 'objectType'

module.exports = mongoose.model 'Aggregate', AggregateSchema

###
ListSchema.pre 'validate', (next)->
  collection = this
  if !collection.isModified 'slug'
    return next()
  collection.email = collection.slug+'@mapkido.com'
  return next()
###


#TODO: slugs cannot be ids: Types.String().regex(/^[0-9a-fA-F]{24}$/)
