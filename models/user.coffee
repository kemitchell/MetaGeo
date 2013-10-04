###
  :: User
  -> model
###

mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'
bcrypt = require 'bcrypt'
collectionSchema = require './collectionSchema'
_ = require 'lodash'

Schema = mongoose.Schema

userSchema = collectionSchema.extend
  password:
    type: String
    required: true
  email:
    type: String
    unique: true
    required: true

userSchema.pre 'save', (next)->
  user = this
  if !user.isModified 'password'
    return next();
  bcrypt.genSalt 10, (err,salt)->
    if err
      next err
    bcrypt.hash user.password, salt, (err,hash)->
      if err
        next err
      user.password = hash
      next()

userSchema.method 'comparePassword', (candidatePassword, cb)->
  bcrypt.compare candidatePassword, this.password, (err,isMatch)->
    if err
      cb err
    cb null, isMatch



#userSchema.options.toJSON = {}
#userSchema.options.toJSON.transform = (doc, ret, options)->
#  ret.id = ret._id
#  delete ret._id
#  delete ret.hash
#  delete ret.salt
#  undefined

#this could a been automated
User = mongoose.model('User', userSchema)

module.exports = User

