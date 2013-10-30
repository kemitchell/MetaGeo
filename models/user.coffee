###
  :: User
  -> model
###

AggregateSchema = require('./aggregate').schema
mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'

UserSchema = AggregateSchema.extend
  username:
    type: String
    unique: true
    sparse: true
    required: true
  salt:
    type: String
  hash:
    type: String
  email:
    type: String
    unique: true
    sparse: true
    required: true

UserSchema.options.toJSON =
  transform: (doc, ret, options)->
    #remove things we dont want the API to return
    ret.eventsUrl = "/events/user/" + ret.username + "/"
    ret.id = ret._id
    delete ret._id
    delete ret.__v
    delete ret.hash
    delete ret.salt
    undefined

validateEmail = (email)->
  emailRegex = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/
  emailRegex.test(email)

UserSchema.path('email').validate validateEmail, 'The e-mail field must be a valid email'

validateUsername = (username)->
  #usernames cannot be like a mongo id
  usernameRegex = /^[0-9a-fA-F]{24}$/
  not usernameRegex.test(username)

UserSchema.path('email').validate validateUsername, 'Invalid username'
User = mongoose.model('user', UserSchema)
module.exports = User
