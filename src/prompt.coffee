clc = require 'cli-color'
readline = require 'readline'
EventEmitter = require('events').EventEmitter
config = require './config'
util = require 'util'

class Prompt extends EventEmitter
	constructor: ->
		@clc = clc
		@rl = readline.createInterface
			input: process.stdin
			output: process.stdout

		@rl.setPrompt(config.prompt, config.prompt.length)

		@rl.on 'line', (msg)=>
			@rl.prompt()
			msg = msg.trim()
			if msg.length > 0 then @emit 'line', msg

		@rl.prompt()

	log: =>
		@rl.pause()
		cpos = @rl.cursor
		# put in a new line for the output
		@_write '\u001b[0G'+'\u001b[2K'
		@_write clc.bol()
		@_println()
		@_write clc.up(1)

		@_log msg for msg in arguments
		@_println()

		@rl.prompt()
		if (@rl.output.cursorTo)
			@rl.output.cursorTo config.prompt.length + cpos
		@rl.cursor = cpos
		@rl.resume()
	_log: (msg)->
		if typeof msg != "string" then msg = util.inspect(msg)
		@_write msg
		@_write ' '
	_println: ->
		process.stdout.write '\n'
	_write: (data)->
		process.stdout.write data

module.exports = Prompt
