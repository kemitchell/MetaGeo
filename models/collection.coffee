###
  :: Collection
  -> model
###

mongoose = require('mongoose')
Schema = mongoose.Schema

collectionSchema = new Schema
  title:
    type: String
  description:
    type: String
  actor:
    type: String
  subscription:
    type: [Number]

#this could a been automated
Collection = mongoose.model('Collection', userSchema)
module.exports = Collection
