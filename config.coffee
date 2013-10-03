module.exports =

  api:
    geo:
      bounds:[[[-88.41796875, 41.1455697310095], [-88.41796875, 42.48019996901214], [-86.737060546875, 42.48019996901214], [-86.737060546875, 41.1455697310095], [-88.41796875, 41.1455697310095]]]
      center: [ -87.57202148437499, 41.83682786072714]
    events:
      maxLimit: 30
      defaults:
        order: "startDateTime ASC"
        limit: 30

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