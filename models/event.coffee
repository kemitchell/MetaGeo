###
  :: Event
  -> model
###
gjVal = require "geojson-validation"
_ = require "lodash"
mongoose = require 'mongoose'
createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin
Schema = mongoose.Schema

eventSchema = new Schema({
  actor:
    type: String
    required: true
  start:
    type: Date
    required: true
  geometry:
    type:
      type: String
    coordinates: []
  content:
    required: true
    type: String
  #what collections was this event posted to
  collections:
    type: [Number]
  #if the event has both goe and time info
  complete:
    type: Boolean

  objectType:
    type: String
    default: "mblog"}

  collection : 'events'
  discriminatorKey: 'objectType')

eventSchema.index {geometry: '2dsphere'}
#add custom defs for JSON
eventSchema.options.toJSON = {}
eventSchema.options.toJSON.transform = (doc, ret, options)->
  ret.id = ret._id
  delete ret._id
  delete ret.__v
  undefined

eventSchema.plugin createdModifiedPlugin, {createdName: "published", modifiedName: "updated" }

#this could a been automated
Event = mongoose.model 'Event', eventSchema
module.exports = Event
