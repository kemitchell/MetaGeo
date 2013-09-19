# event map
### a real-time event mapping application

### Setup
* install redis and mongdb
* clone the repositry: `git clone https://github.com/CraveProgrammingInc/EventMap.git`  
* `cd EventMap`  
* install packages: `npm install`  
* run `node app.js` 

### Install Front-End
* install bower globally `sudo npm install bower -g`
* `cd assets`
* `bower install`
* Install Leaflet
  * `cd bower_components/leaflet`
  * install jake globally `sudo npm install -g jake`
  * then install all else `npm install`

### Test API
* Make sure redis and mongdb are running
* start server: `node app.js`
* run test: `npm test`   
