module.exports =
  mongo:
    host: process.env.IP
    port: 27017
    database: "em"
#    password: process.env.MONGO_PASSWORD || process.env.OPENSHIFT_MONGODB_DB_PASSWORD
#    user: process.env.MONGO_USERNAME || process.env.OPENSHIFT_MONGODB_DB_USERNAME
