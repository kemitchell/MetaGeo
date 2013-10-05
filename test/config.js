module.exports = {
  server: {
    port: 1338 
  },
  mongo:{
    database: "test",
    host: process.env.MONGO_HOST || process.env.OPENSHIFT_MONGODB_DB_HOST || process.env.IP || "localhost",
    port: process.env.MONGO_PORT || process.env.OPENSHIFT_MONGODB_DB_PORT || 27017
  },
  url: 'http://0.0.0.0:1338',
  username: "testUser21",
  password: "password"
}
