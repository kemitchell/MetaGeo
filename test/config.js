//this config file is merged with the one in the root directory
module.exports = {
  //delete the test data?
  //dontDelete:true,
  server: {
    port: 1338
  },
  db:{
    database: "test"
  },
  test:{
    url: 'http://localhost:1338',
  },
  A:{
    user:{
      username: "userA",
      password: "password",
      email: "userA@emial.com"
    },
    bounds: [[-87.885132, 42.051332],[-87.533569, 41.71393]],
  },
  B:{
    user:{
      username: "userB",
      password: "password",
      email: "userB@emial.com"
    },
    bounds: [[-88.885132, 43.051332],[-88.533569, 42.71393]]
  }
}
