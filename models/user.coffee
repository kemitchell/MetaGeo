###
  :: User
  -> model
###

mongoose = require 'mongoose'
extend = require 'mongoose-schema-extend'
bcrypt = require 'bcrypt'
aggregateSchema = require './aggregateSchema'
_ = require 'lodash'

Schema = mongoose.Schema

userSchema = aggregateSchema.extend
  password:
    type: String
    required: true

userSchema.pre 'save', (next)->
  user = this
  if !user.isModified 'password'
    return next()
  if user.password.length < 8
    return next(new Error 'Password must be >= 8')
  bcrypt.genSalt 10, (err,salt)->
    if err
      next err
    bcrypt.hash user.password, salt, (err,hash)->
      if err
        next err
      user.password = hash
      next()
      
userSchema.pre 'save', (next)->
    user = this
    if !user.isModified 'email'
      return next()
    valid = /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/.test user.email
    if !valid
      return next(new Error 'The email is in an invalid format')
    return next()
    
userSchema.method 'comparePassword', (candidatePassword, cb)->
  bcrypt.compare candidatePassword, this.password, (err,isMatch)->
    if err
      cb err
    cb null, isMatch

User = mongoose.model 'User', userSchema

module.exports = User

