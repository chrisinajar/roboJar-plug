EventEmitter = require('events').EventEmitter

class UserCache extends EventEmitter
	constructor: (data, @logger, @bot)->

		@bot.on 'userJoin', (data)=>
			@userJoin data
		@bot.on 'userLeave', (data)=>
			@userLeave data

		@bot.on 'chat', (data)=>
			@cache?.updateChatIdle data.fromID

#		@bot.on 'chat', (data)=>
#			@cache?.updateChatIdle data.id

		@seedData data
		#@logger.log data

	count: =>
		if (@cache)
			return @cache.count()
		else
			return 0
	seedData: (data)=>
		@cache = new HashCache @logger
		@cache.addUser entry.id, entry for entry in data
		@emit 'changed'
		
	userJoin: (data)=>
		@logger.log @logger.clc.yellow("#{data.username} has joined")
		@cache.addUser data.id, data
		@emit 'changed'
	userLeave: (data)=>
		userInfo = @cache.getUser data.id
		@logger.log @logger.clc.yellow("#{userInfo.username} has left")
		@cache.removeUser data.id
		@emit 'changed'
	setLogger: (obj)->
		@logger = obj

class HashCache
	constructor: (@logger)->
		@hash = {}
		@usernameHash = {}
	addUser: (userid, data)->
		@hash[userid] = data
		@usernameHash[data.username] = userid
		data.idle =
			chat: (new Date).getTime()
			vote: (new Date).getTime()
	updateChatIdle: (userid)->
		@getUser(userid).idle.chat = (new Date).getTime()
	updateVoteIdle: (userid)->
		@getUser(userid).idle.vote = (new Date).getTime()
	removeUser: (userid)->
		delete @hash[userid]
	getUser: (userid)->
		return @hash[userid]
	lookupUsername: (username)->
		return @usernameHash[username]
	count: ->
		c = 0
		for i of @hash
			c++
		return c


module.exports = UserCache
