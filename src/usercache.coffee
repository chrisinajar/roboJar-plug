EventEmitter = require('events').EventEmitter

class UserCache extends EventEmitter
	constructor: (data, @logger, @bot)->
		@bot.on 'userJoin', @userJoin
		@bot.on 'userLeave', @userLeave
		@db = false
		@cache = false
	setDatabase: (db)->
		if (@cache)
			throw new Error "You cannot initialize the database connection after the user cache has been seeded."
		@db = db
	seedData: (data)=>
		@cache
	userJoin: (data)=>
	userLeave: (data)=>
	setLogger: (obj)->
		@logger = obj


module.exports = UserCache
