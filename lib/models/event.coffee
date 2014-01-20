###
  :: Event
  -> model
###
mongoose = require 'mongoose'
createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin
Schema = mongoose.Schema

EventSchema = new Schema({
  actor:
    type: String
    required: true
  start:
    type: Date
    required: true
  geometry:
    type:
      type: String
      required: true
    coordinates: []
  content:
    type: String
  #what lists this event is in
  lists:
    type: [Schema.Types.ObjectId]
  #if the event has both geo and time info
  complete:
    type: Boolean

  objectType:
    type: String
    default: "mblog"}

  collection : 'events'
  discriminatorKey: 'objectType')

EventSchema.index {geometry: '2dsphere'}

#add custom defs for JSON
EventSchema.options.toJSON =
  transform: (doc, ret, options)->
    ret.id = ret._id
    delete ret._id
    delete ret.__v
    undefined

EventSchema.plugin createdModifiedPlugin, {createdName: "published", modifiedName: "updated" }
Event = mongoose.model 'event', EventSchema

module.exports = Event
