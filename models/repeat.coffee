###
  :: Repeat
  -> model
###

mongoose = require 'mongoose'
Schema = mongoose.Schema

repeatSchema = new Schema
  year:
    type: String
  month:
    type: String
  day:
    type: String
  hours:
    type: String
  numOfRepeats:
    type: Number

Repeat = mongoose.model 'Repeat', userSchema
module.exports = Repeat
