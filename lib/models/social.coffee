EventSchema = require('./event').schema
mongoose = require 'mongoose'
extend = require('mongoose-schema-extend')

SocialSchema = EventSchema.extend
  title:
    type: String
    required: true
  externalId: String
  end:
    type: Date
  address:
    type: String
  venue:
    type: String
  venueId: String
  link:
    type: String
  # many to one
  repeat_id:
    type: String
  repeat:
    type: Boolean

module.exports  =  mongoose.model 'social' ,  SocialSchema