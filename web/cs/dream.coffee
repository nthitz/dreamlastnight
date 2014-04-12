dataLoader = require('./dataLoader.coffee')
init = () ->
	dataLoader.on('loaded', dreamsDreamt)

dreamsDreamt = (dreams) ->
	console.log 'loaded'
	console.log dreams


init()