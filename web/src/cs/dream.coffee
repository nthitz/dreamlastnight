THREE = require('threejs')

views = require('./dreamViews.coffee')
DreamAssetLoader = require('./dreamAssetLoader.coffee')
tweetDivView = require './views/tweetDivView.coffee'

class Dream
	assets = null
	initialAssetsLoaded: () =>
		tweetDivView.init(assets.data)
		views.applyView('default', assets, @scene, @camera)
	loadInitial: () ->
		assets = new DreamAssetLoader(@dreamData)
		numToLoad = 10
		assets.loadInitial(numToLoad)
		assets.loadMore()
		assets.on('loaded', @initialAssetsLoaded)
	update: () ->
		views.updateView()
	constructor: (@dreamData, @scene, @camera) ->

		

module.exports = Dream