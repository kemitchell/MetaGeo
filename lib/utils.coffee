###
A few utilitly functions, mostly geospatial related
###
_ = require 'lodash'
geoLocation = require 'GeoLocation'
#in meters
EarthsRadus = 6356752

utils =
  ###
  A function that changes a bounding box into a geojson polygon
  @method bboxToPoly
  @param box a bounding box give two comma seperated cooridantes
  @return {Object} the geojson polygon
  ###
  bboxToPoly: (box)->
    if not _.isArray box
      box = box.split ','

    box = box.map (e)->
      Number e

    type: "Polygon"
    coordinates: [[[box[0], box[1]],
                  [box[0], box[3]],
                  [box[2], box[3]],
                  [box[2], box[1]],
                  [box[0], box[1]]]]

  ###
  turns a circle into a geojson polygon that encompasses the circle
  @method circleToPoly
  @param {Array} center a cooridnate pair of the center of the circle
  @param {Number} radius
  @returns {Object}
  ###
  circleToPoly: (center, distance)->
    geoLoc = geoLocation(center[1], center[0])
    bounds = geoLoc.boundingCoordinates(distance, EarthsRadus)
    return bboxToPoly [bounds[0].lng, bounds[0].lat, bounds[1].lng, bounds[1].lat]



  ###
  Cacluates the distance between to points
  @method distance
  @param {Array} p1 point one
  @param {Array} p2 point two
  @returns {Number}
  ###
  distance: (p1, p2)->
    geoP1 = geoLocation.fromDegrees p1[1], p1[0]
    geoP2 = geoLocation.fromDegrees p2[1], p2[0]
    return geoP1.distanceTo(geoP2, EarthsRadus)
    



module.exports = utils
