EventSchema = require('./event').schema
mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'

MblogSchema = EventSchema.extend {}

#timestamp mblogs
MblogSchema.pre 'validate', (next)->
  @start = new Date()
  next()

module.exports  =  mongoose.model 'mblog' , MblogSchema
