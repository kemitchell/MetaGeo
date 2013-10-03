EventSchema = require('./event').schema
mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'

MblogSchema = EventSchema.extend({})

module.exports  =  mongoose.model 'mblog' , MblogSchema
