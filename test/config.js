//this config file is merged with the one in the root directory
module.exports = {
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
    boundsA: [[42.051332, -87.885132],[41.71393, -87.533569]],
    boundsB: [[43.051332, -88.885132],[42.71393, -88.533569]]
  }
}
