THREE = require('threejs')

views = require('./dreamViews.coffee')
DreamAssetLoader = require('./dreamAssetLoader.coffee')
tweetDivView = require './views/tweetDivView.coffee'
config = require('./config.coffee').get()

class Dream
	curView = null
	assets = null
	initialAssetsLoaded: () =>
		tweetDivView.init(assets.data)
		@applyView('default', assets, @scene, @camera)
	loadInitial: () ->
		assets = new DreamAssetLoader(@dreamData)
		numToLoad = config.initial
		assets.loadInitial(numToLoad)
		assets.on('loaded', @initialAssetsLoaded)
	update: () ->
		if curView?
			curView.view.update()

	applyView: (viewName, assets, scene, camera) ->
		curView = _.find(views, (view) -> view.name is viewName)
		curView.view.initView(assets, scene, camera)

		
	constructor: (@dreamData, @scene, @camera) ->

		

module.exports = Dream