THREE = require('threejs')
EventEmitter = require('EventEmitter')

DreamAssetLoader = require('./dreamAssetLoader.coffee')
tweetDivView = require './views/tweetDivView.coffee'
config = require('./config.coffee').get()
manager = require('./dreamManager.coffee')

console.log manager
class Dream extends EventEmitter
	curView = null
	assets = null
	requested = false;

	loadInitial: () =>
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
		console.log manager
		

module.exports = Dream