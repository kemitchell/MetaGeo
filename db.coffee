mongoose = require('mongoose')
config =   require('./config')

#build connection string
if config.mongo.password and config.mongo.user
  dbURI = "mongodb://" +
    config.mongo.user + ":" +
    config.mongo.password + "@" +
    config.mongo.host +  ":" +
    config.mongo.port + "/" +
    config.mongo.database
else
  dbURI = "mongodb://" +
    config.mongo.host + ":" +
    config.mongo.port + "/" +
    config.mongo.database

db = {}
db.start = ()->
  mongoose.connect(dbURI)

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

db.stop = ()->
  mongoose.disconnect()

module.exports = db
