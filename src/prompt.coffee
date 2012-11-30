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
		@statusLines = [clc.blackBright 'No status']

		@rl.setPrompt(config.prompt, config.prompt.length)

		@rl.on 'line', (msg)=>
			@pause()
			@clearLines(@statusLines.length+1)
			@_write config.prompt
			@_write msg
			@println()
			msg = msg.trim()
			if msg.length > 0 
				@emit 'line', msg

			
			@prompt()
			@resume()

			
		@prompt()


	clearLines: (count)->
		if (!count)
			count = 1
		for i in [1..count]
			@_write clc.up(1)
			@_write '\u001b[0G'+'\u001b[2K'
	pause: ->
		@rl.pause()
		@cpos = @rl.cursor
	resume: ->
		if (@rl.output.cursorTo)
			@rl.output.cursorTo config.prompt.length + @cpos
		@rl.cursor = @cpos
		@rl.resume()
	setStatusLines: (lines)->
		@pause()
		@clearLines(@statusLines.length)
		@statusLines = lines
		@prompt()
		@resume()

	prompt: =>
		@printStatusLine()
		@rl.prompt()

	log: =>
		@pause()
		# put in a new line for the output
		@_write '\u001b[0G'+'\u001b[2K'
		@clearLines(@statusLines.length)

		@_log msg for msg in arguments
		@println()

		@prompt()
		@resume()

	printStatusLine: =>
		for line in @statusLines
			@_write '\u001b[0G'+'\u001b[2K'
			@_write line
			@println()

	_log: (msg)->
		if typeof msg != "string" then msg = util.inspect(msg)
		@_write msg
		@_write ' '
	println: ->
		process.stdout.write '\n'
	_write: (data)->
		process.stdout.write data

module.exports = Prompt
