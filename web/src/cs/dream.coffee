THREE = require('threejs')

views = require('./dreamViews.coffee')
DreamAssetLoader = require('./dreamAssetLoader.coffee')
class Dream
	assets = null

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
	constructor: (@dreamData, @scene) ->
		initialAssetsLoaded = initialAssetsLoaded.bind( @ )
	

module.exports = Dream