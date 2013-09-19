module.exports =
  server:
    host: process.env.NODE_HOST ||  process.env.OPENSHIFT_NODEJS_IP || "0.0.0.0"
    port: process.env.NODE_PORT ||  process.env.OPENSHIFT_NODEJS_PORT || 1337
    options: {}
    stop:
      timeout: 60 * 1000

  authentication:
    name: 'session'
    options:
      scheme: 'cookie',
      password: 'secret sauce',
      cookie: 'sid-em',
      isSecure: false

  sockjs:
    url:'http://0.0.0.0:1337/echo'

  mongo:
    host: process.env.MONGO_HOST || process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
    port: process.env.MONGO_PORT || process.env.OPENSHIFT_MONGODB_DB_PORT || 27017
    database: process.env.MONGO_DB || process.env.OPENSHIFT_APP_NAME || "em"
    password: process.env.MONGO_PASSWORD || process.env.OPENSHIFT_MONGODB_DB_PASSWORD
    user: process.env.MONGO_USERNAME || process.env.OPENSHIFT_MONGODB_DB_USERNAME
