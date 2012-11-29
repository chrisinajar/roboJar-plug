config = require './config'
PlugAPI = require 'plugapi'
EventEmitter = require('events').EventEmitter
Prompt = require './prompt'

class RoboJar
	constructor: (key)->
		@bot = new PlugAPI key
		@bot.on 'error', @connect
		@bot.on 'close', @connect

		@prompt = new Prompt()
		@prompt.on 'line', (msg)=>
			@bot.chat msg

		@connect()

		@bot.on 'chat', @chat
	chat: (data)=>
		@prompt.log(@prompt.clc.blue(data.from+": ") + data.message)

	connect: =>
		@bot.connect 'coding-soundtrack'

roboJar = new RoboJar(config.auth)
