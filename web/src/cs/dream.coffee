THREE = require('threejs')

DreamAssetLoader = require('./dreamAssetLoader.coffee')
class Dream
	assets = null

	constructor: (@dreamData, @scene) ->
	#	console.log @dreamData
	#	console.log @scene
	loadInitial: () ->
		numWords = 10
		assets = new DreamAssetLoader(@dreamData)
		assets.loadInitial(10)
module.exports = Dream