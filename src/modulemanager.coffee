EventEmitter = require('events').EventEmitter
domain = require 'domain'

class ModuleManager
	constructor: (@logger, @bot)->
		@modules = {}
		@eventProxies = {}
		@domains = {}

	proxyEvent: (event)->
		for name, emitter of @eventProxies
			emitter.emit.apply emitter, event

	getEventProxy: (name)->
		if (@eventProxies[name])
			return @eventProxies[name]

		@eventProxies[name] = new EventEmitter()
		@getDomain(name).add @eventProxies[name]

		return @eventProxies[name]

	getDomain: (name)->
		if (@domains[name])
			return @domains[name]
		d = @domains[name] = domain.create()
		d.on 'error', (er)=>
			@logger.log er
		return @domains[name]

	cleanUp: (name)->
		delete require.cache[require.resolve("./plugins/#{name}")]
		delete @eventProxies[name]
		delete @domains[name]

	loadModule: (name)->
		try
			@logger.log @logger.clc.cyan "About to load " + name
			@unloadModule name
			Module = require("./plugins/#{name}")
			@modules[name] = new Module @logger, @bot
		catch e
			@logger.log @logger.clc.red(e.message) + @logger.clc.cyan(" in " + name)

	unloadModule: (name)->
		try
			@modules[name]?.unload()
		catch e
		finally
			delete @modules[name]
			@cleanUp name



module.exports = ModuleManager