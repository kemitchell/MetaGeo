mongoose = require 'mongoose'
msgpack = require 'msgpack'

subscriptionSchema = new mongoose.Schema
	subscriber:
		type: mongoose.Schema.ObjectId
		required: true
	publisher:
		type: mongoose.Schema.ObjectId
		required: true
	filter:
	    type: Buffer
	    required: true

subscriptionSchema.pre 'save', (next)->
    subscription = this
    if !subscription.isModified 'filter'
        return next()
    this.validateFilter (err)->
        next err
        
subscriptionSchema.method "validateFilter", (cb)->
    unpacked = msgpack.unpack this.filter
    err = new Error('Malformed Filter')
    Object.keys(unpacked).forEach (field)->
        return cb err if field != 'hash' and field != 'source'
        Object.keys(unpacked[field]).forEach (filter)->
            return cb err if filter != 'default' and filter != 'exclude' and filter != 'include'
            if filter == 'default'
                return cb err if unpacked[field][filter] != 'exclude' and unpacked[field][filter] != 'include'
            if filter == 'include' or filter == 'exclude'
                return cb err if !Array.isArray unpacked[field][filter] 
    cb()
    
Subscription = mongoose.model('Subscription', subscriptionSchema)

module.exports = Subscription