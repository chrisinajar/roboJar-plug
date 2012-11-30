EventEmitter = require('events').EventEmitter

class UserCache extends EventEmitter
	constructor: (data, @logger, @bot)->

		@bot.on 'userJoin', @userJoin
		@bot.on 'userLeave', @userLeave
		#@logger.log data
	seedData: (data)=>
		
	userJoin: (data)=>
	userLeave: (data)=>
	setLogger: (obj)->
		@logger = obj


module.exports = UserCache
