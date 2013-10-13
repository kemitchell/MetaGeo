###
  :: Collection
  -> model
###

mongoose = require('mongoose')

aggregateSchema = mongoose.Schema {
  title:
    type: String
    required: true
  description:
    type: String
  slug:
    type: String
    required: true
    unique: true
  email:
    type: String
    required: true
    unique: true
},collection:'aggregate',discriminatorKey: '_type'

aggregateSchema.pre 'save', (next)->
    aggregate = this
    if !aggregate.isModified 'slug'
        return next()
    valid = /^[\w]+$/.test aggregate.slug
    if !valid
        return next(new Error 'The slug is in an invalid format')
    return next()

module.exports = aggregateSchema
