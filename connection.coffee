mongoose = require('mongoose')

#options should be moved to a config file someday
host = process.env.MONGO_HOST || process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
port =  process.env.MONGO_PORT || process.env.OPENSHIFT_MONGODB_DB_PORT || 27017
database = process.env.MONGO_DB || process.env.OPENSHIFT_APP_NAME || "em"

mongo_options =
  password: process.env.MONGO_PASSWORD || process.env.OPENSHIFT_MONGODB_DB_PASSWORD
  user: process.env.MONGO_USERNAME || process.env.OPENSHIFT_MONGODB_DB_USERNAME

#build connection string
dbURI =  process.env.MONGO_URL || "mongodb://" + host +  ":" + port + "/" + database

db = {}
db.start = ()->
  mongoose.connect(dbURI,mongo_options)

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
