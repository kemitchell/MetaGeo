//this config file is merged with the one in the root directory
module.exports = {
  //delete the test data?
  //dontDelete:true,
  server: {
    port: 1338
  },
  mongo:{
    database: "test"
  },
  test:{
    url: 'http://localhost:1338',
    username: "testUser21",
    password: "password",
    email: "test2@email.com",
    boundsA: [[-87.885132, 42.051332],[-87.533569, 41.71393]],
    //outside of boundsA
    boundsB: [[-88.885132, 43.051332],[-88.533569, 42.71393]]
  }
}
