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
    # CONNECTION EVENTS
    # When successfully connected
    mongoose.connection.on "connected", (err)->
      console.log "Mongoose default connection open to " + dbURI

    # If the connection throws an error
    mongoose.connection.on "error", (err) ->
      console.log "Mongoose default connection error: " + err

    mongoose.connection.on 'reconnected', ()->
      console.log 'MongoDB reconnected!'

    # When the connection is disconnected
    mongoose.connection.on "disconnected", ->
      console.log "Mongoose default connection disconnected"

    mongoose.connect dbURI, options, cb

  ###
  @method stop
  @param {Function} cb A callback
  ###
  stop:(cb)->
    mongoose.connection.close cb

module.exports = db
