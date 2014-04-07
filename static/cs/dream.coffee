dataLoader = require('./dataLoader.coffee')
init = () ->
	dataLoader.on('loaded', dreamsDreamt)

dreamsDreamt = (dreams) ->
	console.log dreams


init()