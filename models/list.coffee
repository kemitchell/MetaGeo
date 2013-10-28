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
module.exports = mongoose.model 'Collection', ListSchema
