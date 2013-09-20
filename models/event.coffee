###
  :: Event
  -> model
###
gjVal = require("geojson-validation")
_ = require("lodash")
mongoose = require('mongoose')
Schema = mongoose.Schema

eventSchema = new Schema
  title:
    type: String
    unique: true
  actor:
    type: String
  startDateTime:
    type: String
  endDateTime:
    type: String
  geometry:
    type:
      type: String
    coordinates: []
    #index: '2dsphere'
    #validation: gjVal.isPoint
  content:
    type: String
  #what collections was this event posted to
  collections:
    type: [Number]
  #if the event has both goe and time info
  complete:
    type: Boolean
  #doe the event repeat?
  repeat:
    type: Boolean
  #if so what is its patteren?
  # many to one
  repeat_id:
    type: String
  #what type of event is this
  objectType:
    type: String
    defaultsTo: 'event'

eventSchema.index({geometry: '2dsphere'})

eventSchema.options.toJSON = {}
eventSchema.options.toJSON.transform = (doc, ret, options)->
  ret.id = ret._id
  delete ret._id
  delete ret.__v
  undefined

#this could a been automated
Event = mongoose.model('Event', eventSchema)
module.exports = Event

