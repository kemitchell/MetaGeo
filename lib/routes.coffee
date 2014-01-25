###
Defines the hapi routes for the API
###
eventController = new (require('./controllers/eventController'))()
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
    auth: true
,
  method: "POST"
  path: "/api/user"
  config:
    handler: require("./controllers/userController").create
    auth:
      mode: 'try'
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
    handler: eventController.findOne
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "POST"
  path: "/api/event"
  config:
    handler: eventController.create
    auth: true
,
  method: "POST"
  path: "/api/event/{objectType}"
  config:
    handler: (request)->
      require("./controllers/"+request.params.objectType+"Controller.coffee" ).create.apply @, arguments
    auth: true
,
  method: "PUT"
  path: "/api/event/{objectType}/{_id}"
  config:
    handler: (request)->
      require("./controllers/"+request.params.objectType+"Controller.coffee" ).update.apply @, arguments
    auth: true
,
  method: "DELETE"
  path: "/api/event/{objectType}/{_id}"
  config:
    handler: (request)->
      require("./controllers/"+request.params.objectType+"Controller.coffee" ).update.apply @, arguments
    auth: true
,
  method: "GET"
  path: "/api/event/{objectType}/{_id}"
  config:
    handler: (request)->
      require("./controllers/"+request.params.objectType+"Controller.coffee" ).update.apply @, arguments
    auth: true
,
  method: "PUT"
  path: "/api/event/{_id}"
  config:
    handler: eventController.update
    auth: true
    validate:
      path:
        #id must be an mongo id
        _id: Types.String().regex(/^[0-9a-fA-F]{24}$/)
,
  method: "DELETE"
  path: "/api/event/{_id}"
  config:
    handler: eventController.delete
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
    handler: eventController.find
,
  method: "GET"
  path: "/api/events/{objectType}/"
  config:
    handler: eventController.find
,
  method: "GET"
  path: "/api/events/user/{actor}/"
  config:
    handler: eventController.find
,
  #TODO
  method: "GET"
  path: "/api/events/list/{_id}/"
  config:
    handler: eventController.find
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
,
  #subscriptions
  method: "POST"
  path: "/api/subscription"
  config:
    handler: require("./controllers/subscriptionController").create
,
  method: "PUT"
  path: "/api/subscription/{_id}"
  config:
    handler: require("./controllers/subscriptionController").update
,
  method: "DELETE"
  path: "/api/subsciption/{_id}"
  config:
    handler: require("./controllers/subscriptionController").delete
]
