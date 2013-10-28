###
  :: User
  -> model
###

AggregateSchema = require './aggregateSchema'
mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'

UserSchema = AggregateSchema.extend
  username:
    type: String
    required: true
    unique: true
  salt:
    type: String
  hash:
    type: String
  email:
    type: String
    required: true
    unique: true

UserSchema.options.toJSON =
  transform: (doc, ret, options)->
    #remove things we dont want the API to return
    ret.id = ret._id
    delete ret._id
    delete ret.hash
    delete ret.salt
    undefined

validateEmail = (email)->
  emailRegex = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/
  emailRegex.test(email)

UserSchema.path('email').validate validateEmail, 'The e-mail field cannot be empty.'
User = mongoose.model('User', UserSchema)

module.exports = User
