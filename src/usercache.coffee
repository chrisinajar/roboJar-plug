EventEmitter = require('events').EventEmitter

class UserCache extends EventEmitter
	constructor: (data, logger)->
		@logger = logger || {
			log: ->
				console.log.apply(console, arguments)
		}

		#@logger.log data
	setLogger: (obj)->
		@logger = obj


module.exports = UserCache