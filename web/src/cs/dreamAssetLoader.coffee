_ = require('lodash')
THREE = require('threejs')
d3 = require('d3')
EventEmitter = require('events').EventEmitter
config = require('./config.coffee').get()

class DreamAssetLoader extends EventEmitter
	assetTypes = ['people','terms']
	assets = {}
	textureLoader = null
	imagesLoaded = 0
	maxPerDream = config.max
	imagesRequested = 0
	imagesErrored = 0
	useImageProxy = false
	checkLoadStatus: (allowErrors = true) =>
		loaded = false
		if allowErrors
			loaded = imagesLoaded + imagesErrored is imagesRequested
		else
			loaded = imagesLoaded is imagesRequested
		if loaded
			@emit('loaded')
			@loadMore()

	imageLoadedCallback: () =>
		imagesLoaded += 1
		@checkLoadStatus(true)
	imageProgressHandler = () ->

	imagesErrorHandler: () =>
		imagesErrored += 1
		@checkLoadStatus()
	loadImages: (numImagesToLoad) =>
		console.log 'load images'
		numRequested = 0
		numLoaded = 0
		if numImagesToLoad > @data.images.length
			numImagesToLoad = @data.images.length
		_.each(@data.images, (image) =>
			if image.loaded
				return
			if image.loading
				return
			if numRequested is numImagesToLoad
				return false
			imageLoaded = (texture) =>
				image.texture = texture
				image.loaded = true
				image.loading = false
				numLoaded += 1
				@imageLoadedCallback()
			numRequested += 1
			imagesRequested += 1
			image.loading = true
			if useImageProxy
				image.url = 'http://localhost:5100/' + image.url.substr(8)
			textureLoader.load(image.url, imageLoaded, imageProgressHandler, @imagesErrorHandler)
		)
	
	loadMore: () =>
		image = _.find(@data.images, (d) -> ! d.loaded && ! d.loading)
		if not image?
			return
		image.loading = true
		if useImageProxy
			image.url = 'http://localhost:5100/' + image.url.substr(8)
		imageLoaded = (texture) =>
			image.texture = texture
			image.loaded = true
			image.loading = false
			imagesLoaded += 1
			@emit('moreImages', image)
			if imagesLoaded < maxPerDream
				@loadMore()	
		#console.log 'load more ' + image.url
		textureLoader.load(image.url, imageLoaded, imageProgressHandler, @loadMore)



	loadingProgress = (e) ->
		console.log e
	loadInitial: (numToLoad) =>
		console.log @data
		@loadImages(numToLoad)


	constructor: (@data) ->

		
		textureLoader = new THREE.TextureLoader()
		console.log @data
		d3.shuffle(@data.images)

module.exports = DreamAssetLoader