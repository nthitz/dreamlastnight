THREE = require('threejs')

views = require('./dreamViews.coffee')
DreamAssetLoader = require('./dreamAssetLoader.coffee')
class Dream
	assets = null

	constructor: (@dreamData, @scene) ->
	#	console.log @dreamData
	#	console.log @scene
	initialAssetsLoaded = () ->
		console.log 'loaded'
		console.log assets
		views.applyView('default', assets, @scene)
	loadInitial: () ->
		numWords = 10
		console.log numWords
		assets = new DreamAssetLoader(@dreamData)
		assets.loadInitial(10)
		assets.on('loaded', initialAssetsLoaded)
module.exports = Dream