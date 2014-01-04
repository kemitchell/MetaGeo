###
A few utilitly functions, mostly geospatial related
###
_ = require 'lodash'

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
  circleToPoly: (center, radius)->
    type: "Polygon"
    coordinates: [[[center[0] - radius], [center[1] - radius],
                  [center[0] + radius], [center[0] - radius],
                  [center[0] - radius], [center[0] + radius],
                  [center[0] + radius], [center[0] + radius]]]

  ###
  Cacluates the distance between to points
  @method distance
  @param {Array} p1 point one
  @param {Array} p2 point two
  @returns {Number}
  ###
  distance: (p1, p2)->
    Math.squrt(Math.pow(p1[0] - p2[0], 2) + Math.pow(p1[1] - p2[1]))

module.exports = utils
