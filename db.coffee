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
    if options.password and options.user
      dbURI = "mongodb://" +
        options.user + ":" +
        options.password + "@" +
        options.host +  ":" +
        options.port + "/" +
        options.database
    else
      dbURI = "mongodb://" +
        options.host + ":" +
        options.port + "/" +
        options.database

    mongoose.connect dbURI, cb
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

    # If the Node process ends, close the Mongoose connection
    process.on "SIGINT", ->
      mongoose.connection.close ->
        console.log "Mongoose default connection disconnected through app termination"
        process.exit 0

  ###
  @method stop
  @param {Function} cb A callback
  ###
  stop:(cb)->
    mongoose.disconnect cb

module.exports = db
