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
  path: "/config"
  config:
    handler: require("./controllers/configController")
,
  #auth
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
    auth: true
,
  #user
  method: "GET"
  path: "/user/{id}"
  config:
    handler: require("./controllers/userController").find
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "PUT"
  path: "/user/{id}"
  config:
    handler: require("./controllers/userController").update
    payload: "parse"
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
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
    auth: true
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  #event collections
  method: "GET"
  path: '/events/'
  config:
    handler: require("./controllers/eventController").find
,
  #event CRUD
  method: "GET"
  path: "/event/"
  config:
    handler: require("./controllers/eventController").find
,
  method: "GET"
  path: "/event/{id}"
  config:
    handler: require("./controllers/eventController").find
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "GET"
  path: "/event/{objectType}/"
  config:
    handler: require("./controllers/eventController").find
,
  method: "GET"
  path: "/events/{objectType}/"
  config:
    handler: require("./controllers/eventController").find
,
  method: "POST"
  path: "/event"
  config:
    handler: require("./controllers/eventController").create
    auth: true
,
  method: "POST"
  path: "/event/{objectType}"
  config:
    handler: require("./controllers/eventController").create
    auth: true
,
  method: "PUT"
  path: "/event/{id}"
  config:
    handler: require("./controllers/eventController").update
    auth: true
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "DELETE"
  path: "/event/{id}"
  config:
    handler: require("./controllers/eventController").delete
    auth: true
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,

  #lists
  method: "POST"
  path: "/l"
  config:
    handler: require("./controllers/listController").create
    auth: true
,
  method: "GET"
  path: "/l/{id}"
  config:
    handler: require("./controllers/listController").find
    auth: true
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "PUT"
  path: "/l/{id}"
  config:
    handler: require("./controllers/listController").update
    auth: true
,
  method: "DELETE"
  path: "/l/{id}"
  config:
    handler: require("./controllers/listController").delete
    auth: true
    validate:
      path:
        #id must be an mongo id
        id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
]
