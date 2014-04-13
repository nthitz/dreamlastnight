dataLoader = require('./dataLoader.coffee')
THREE = require('three')
Stats = require('Stats')
_ = require('lodash')
init = () ->
	dataLoader.on('loaded', dreamsDreamt)

dreamsDreamt = (dreams) ->
	console.log 'loaded'
	console.log dreams
	console.log THREE
	
	_.each(dreams,(dream) ->
	)


init()