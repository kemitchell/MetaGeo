mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'
aggregateSchema = require('./aggregate').schema

ListSchema = aggregateSchema.extend
  actor:
    type: String
    required: true
  title:
    type: String
    required: true

ListSchema.options.toJSON =
  transform: (doc, ret, options)->
    ret.id = ret._id
    delete ret._id
    delete ret.__v
    undefined

module.exports = mongoose.model 'list', ListSchema
