###
  :: User
  -> model
###

mongoose = require('mongoose')
Schema = mongoose.Schema

userSchema = new Schema
  username:
    type: String,
    unique: true
  salt:
    type: String
  hash:
    type: String
  email:
    type: String
  objectType:
    type: String
    default: "person"

userSchema.options.toJSON = {}
userSchema.options.toJSON.transform = (doc, ret, options)->
  ret.id = ret._id
  delete ret._id
  delete ret.hash
  delete ret.salt
  undefined

User = mongoose.model('User', userSchema)

module.exports = User
