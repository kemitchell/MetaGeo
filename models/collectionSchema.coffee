###
  :: Collection
  -> model
###

mongoose = require('mongoose')
Schema = mongoose.Schema

module.exports = collectionSchema = mongoose.Schema {
  title:
    type: String,
    required: true
  description:
    type: String },
  collection:'collections',discriminatorKey: '_type'
  