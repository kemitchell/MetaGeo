Types = require("hapi").types

module.exports = [
  method: "GET"
  path: "/{path*}"
  config:
    handler:
      directory:
        path: './assets/dist'
    description: "servering static files"
    notes: ["this probably should change to /static/{*}"]
    tags: ['static']
,
  method: "GET"
  path: "/config"
  config:
    handler: require("./controllers/configController")
,
  method: "GET"
  path: "/login"
  config:
    handler: require("./controllers/authController").status
    auth:
      mode: 'try'
,
  method: "POST"
  path: "/login"
  config:
    handler: require("./controllers/authController").process
    auth:
      mode: 'try'
    payload: "parse"
,
  method: "DELETE"
  path: "/login"
  config:
    handler: require("./controllers/authController").logout
    auth:true
,
  method: "GET"
  path: "/user/{id}"
  config:
    handler: require("./controllers/userController").find
,
  method: "PUT"
  path: "/user/{id}"
  config:
    handler: require("./controllers/userController").update
    payload: "parse"
,
  method: "POST"
  path: "/user"
  config:
    handler: require("./controllers/userController").create
    payload: "parse"
,
  method: "DELETE"
  path: "/user/{id}"
  config:
    handler: require("./controllers/userController").delete
,
  #event
  method: "GET"
  path: '/events/'
  config:
    handler: require("./controllers/eventController").find
,
  method: "GET"
  path: "/event/"
  config:
    handler: require("./controllers/eventController").find
,
  method: "GET"
  path: "/event/{id}"
  config:
    handler: require("./controllers/eventController").find
,
  method: "GET"
  path: "/event/{type}/"
  config:
    handler: require("./controllers/eventController").find
    auth:true
,

  method: "GET"
  path: "/events/{type}/"
  config:
    handler: require("./controllers/eventController").find
    auth:true
,
  method: "POST"
  path: "/event"
  config:
    handler: require("./controllers/eventController").create
    auth:true
,

  method: "POST"
  path: "/event/{type}"
  config:
    handler: require("./controllers/eventController").create
    auth:true
,
  method: "PUT"
  path: "/event/{id}"
  config:
    handler: require("./controllers/eventController").update
,
  method: "DELETE"
  path: "/event/{id}"
  config:
    handler: require("./controllers/eventController").delete
]
