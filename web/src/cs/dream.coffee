THREE = require('threejs')
EventEmitter = require('EventEmitter')

DreamAssetLoader = require('./dreamAssetLoader.coffee')
tweetDivView = require './views/tweetDivView.coffee'
config = require('./config.coffee').get()
class Dream extends EventEmitter
	curView = null
	assets = null
	requested = false;
	error = false
	loadInitial: () =>
		if error
			return
		requested = true
		assets = new DreamAssetLoader(@dreamData)
		numToLoad = config.initial
		assets.loadInitial(numToLoad)
		assets.on('loaded', () =>
			tweetDivView.init(assets.data)
			@emit('loaded', assets)
		)

	beenRequested: () ->
		return requested
	constructor: (@dreamData) ->
		if typeof @dreamData.images is 'undefined'
			error = true
			console.error 'dream has no images'
		else
			@dreamData.images = _.map(@dreamData.images, (url) ->
				return { url: url }
			)
		

module.exports = Dream