mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'
aggregateSchema = require './aggregateSchema'

ListSchema = aggregateSchema.extend({})
###
ListSchema.pre 'validate', (next)->
  collection = this
  if !collection.isModified 'slug'
    return next()
  collection.email = collection.slug+'@mapkido.com'
  return next()
###

ListSchema.options.toJSON =
  transform: (doc, ret, options)->
    ret.id = ret._id
    delete ret._id
    delete ret.__v
    undefined

module.exports = mongoose.model 'List', ListSchema
