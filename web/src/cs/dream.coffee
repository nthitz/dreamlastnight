THREE = require('threejs')

views = require('./dreamViews.coffee')
DreamAssetLoader = require('./dreamAssetLoader.coffee')
tweetDivView = require './views/tweetDivView.coffee'

class Dream
	assets = null
	initialAssetsLoaded: () =>
		console.log 'loaded'
		console.log @dreamData
		console.log assets
		tweetDivView.init(assets.data)
		console.log tweetDivView
		views.applyView('default', assets, @scene, @camera)
	loadInitial: () ->
		console.log @dreamData.embed_html
		assets = new DreamAssetLoader(@dreamData)
		assets.loadInitial(40)
		assets.on('loaded', @initialAssetsLoaded)
	update: () ->
		views.updateView()
	constructor: (@dreamData, @scene, @camera) ->
		console.log @dreamData
		

module.exports = Dream