# MetaGeo  [![Build Status](https://travis-ci.org/craveprogramminginc/MetaGeo.png?branch=master)](https://travis-ci.org/craveprogramminginc/MetaGeo)
### a real-time event mapping framework

Metageo is a set of hapi plugins that form a spatial and temporal RESTful server. It allows you to easily map anything that happens somewhere and at sometime.  




### Setup
* install [mongodb](http://docs.mongodb.org/manual/installation/) 2.4 or above
* clone the repositry: `git clone https://github.com/craveprogramminginc/MetaGeo`  
* `cd MetaGeo`  
* install packages: `npm install`  
* run `node ./bin/metageo` 

### Configuration
See the [configuration documentation](https://github.com/craveprogramminginc/MetaGeo/wiki/Configuration)

### Plugins
You can use any hapi plugin with metageo but there are a few plugins written just for metageo
* [metageo-mblog-api](https://github.com/craveprogramminginc/metageo-mblog-api) Provides micro-blog like event REST API
* [metageo-social-api](https://github.com/craveprogramminginc/metageo-social-api) Provides a socail event REST API
* [metageo-pubsub](https://github.com/craveprogramminginc/metageo-pubsub) Provides a Real Time subcription publication API
* [metageo-pubsub-websockets](https://github.com/craveprogramminginc/metageo-pubsub-websockets) Provides websockets as transport for pub/sub

To use them install them with npm or clone them with git then add their location to your configuration file under plugins

### API
* [RESTful API](https://github.com/craveprogramminginc/MetaGeo/wiki/API)
* [Streaming API](https://github.com/craveprogramminginc/MetaGeo/wiki/Streaming-API)

### API Tests
* run test: `npm test`   

### Contact
* [Mailing List](https://groups.google.com/a/craveprogramming.com/forum/#!forum/metageo-dev)
* IRC #metageo on freenode
