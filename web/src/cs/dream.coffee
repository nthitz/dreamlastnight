THREE = require('threejs')

views = require('./dreamViews.coffee')
DreamAssetLoader = require('./dreamAssetLoader.coffee')
class Dream
	assets = null

	initialAssetsLoaded = () ->
		console.log 'loaded'
		console.log assets
		views.applyView('default', assets, @scene, @camera)

	loadInitial: () ->
		assets = new DreamAssetLoader(@dreamData)
		assets.loadInitial(40)
		assets.on('loaded', initialAssetsLoaded)
	update: () ->
		views.updateView()
	constructor: (@dreamData, @scene, @camera) ->
		initialAssetsLoaded = initialAssetsLoaded.bind( @ )
	

module.exports = Dream