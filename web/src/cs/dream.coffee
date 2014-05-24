THREE = require('threejs')

views = require('./dreamViews.coffee')
DreamAssetLoader = require('./dreamAssetLoader.coffee')
tweetDivView = require './views/tweetDivView.coffee'
config = require('./config.coffee').get()

class Dream
	assets = null
	initialAssetsLoaded: () =>
		tweetDivView.init(assets.data)
		views.applyView('default', assets, @scene, @camera)
	loadInitial: () ->
		assets = new DreamAssetLoader(@dreamData)
		numToLoad = config.initial
		assets.loadInitial(numToLoad)
		assets.loadMore()
		assets.on('loaded', @initialAssetsLoaded)
	update: () ->
		views.updateView()
	constructor: (@dreamData, @scene, @camera) ->

		

module.exports = Dream