###
Manages the DB
###

mongoose = require 'mongoose'
server   = require('hapi').server

db =
  ###
  Connects to the DB
  @options {Object}
  @options.user {String}
  @options.password {String}
  @options.host {String}
  @options.database {String}
  ###
  start:(options, cb)->
    #build connection string
    dbURI = "mongodb://" +
      options.uri.host + ":" +
      options.uri.port + "/" +
      options.uri.database

    console.log dbURI
    mongoose.connect dbURI, options, cb
    # CONNECTION EVENTS
    # When successfully connected
    mongoose.connection.on "connected", ->
      console.log "Mongoose default connection open to " + dbURI

    # If the connection throws an error
    mongoose.connection.on "error", (err) ->
      console.log "Mongoose default connection error: " + err

    # When the connection is disconnected
    mongoose.connection.on "disconnected", ->
      console.log "Mongoose default connection disconnected"

  ###
  @method stop
  @param {Function} cb A callback
  ###
  stop:(cb)->
    mongoose.connection.close ->
      if cb
        cb()

module.exports = db
