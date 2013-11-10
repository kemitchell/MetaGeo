###
Defines the hapi routes for the API
###

Types = require("hapi").types
module.exports = [
  #static assests
  #TODO: change to /static maybe
  method: "GET"
  path: "/{path*}"
  config:
    handler:
      directory:
        path: './assets/dist'
,
  #config
  method: "GET"
  path: "/api/config"
  config:
    handler: require("./controllers/configController")
,
  #auth
  method: "GET"
  path: "/api/login"
  config:
    handler: require("./controllers/authController").status
    auth:
      mode: 'try'
,
  method: "POST"
  path: "/api/login"
  config:
    handler: require("./controllers/authController").process
    auth:
      mode: 'try'
    payload: "parse"
,
  method: "DELETE"
  path: "/api/login"
  config:
    handler: require("./controllers/authController").logout
    auth: true
,
  #user
  method: "GET"
  path: "/api/user/{username}"
  config:
    handler: require("./controllers/userController").findOne
,
  method: "PUT"
  path: "/api/user/{username}"
  config:
    handler: require("./controllers/userController").update
    payload: "parse"
    auth: true
,
  method: "POST"
  path: "/api/user"
  config:
    handler: require("./controllers/userController").create
    payload: "parse"
,
  method: "DELETE"
  path: "/api/user/{username}"
  config:
    handler: require("./controllers/userController").delete
    auth: true
,
  method: "GET"
  path: "/api/event/{_id}"
  config:
    handler: require("./controllers/eventController").findOne
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "POST"
  path: "/api/event"
  config:
    handler: require("./controllers/eventController").create
    auth: true
,
  method: "POST"
  path: "/api/event/{objectType}"
  config:
    handler: require("./controllers/eventController").create
    auth: true
,
  method: "PUT"
  path: "/api/event/{_id}"
  config:
    handler: require("./controllers/eventController").update
    auth: true
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "DELETE"
  path: "/api/event/{_id}"
  config:
    handler: require("./controllers/eventController").delete
    auth: true
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  #event collections
  method: "GET"
  path: '/api/events/'
  config:
    handler: require("./controllers/eventController").find
,
  method: "GET"
  path: "/api/events/{objectType}/"
  config:
    handler: require("./controllers/eventController").find
,
  method: "GET"
  path: "/api/events/user/{actor}/"
  config:
    handler: require("./controllers/eventController").find
,
  #TODO
  method: "GET"
  path: "/api/events/list/{_id}/"
  config:
    handler: require("./controllers/eventController").find
,
  #lists
  method: "POST"
  path: "/api/list"
  config:
    handler: require("./controllers/listController").create
    auth: true
,
  method: "GET"
  path: "/api/list/{_id}"
  config:
    handler: require("./controllers/listController").findOne
    auth: true
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "PUT"
  path: "/api/list/{_id}"
  config:
    handler: require("./controllers/listController").update
    auth: true
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "DELETE"
  path: "/api/list/{_id}"
  config:
    handler: require("./controllers/listController").delete
    auth: true
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
]
