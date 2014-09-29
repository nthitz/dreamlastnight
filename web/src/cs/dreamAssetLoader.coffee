_ = require('lodash')
THREE = require('threejs')
d3 = require('d3')
EventEmitter = require('events').EventEmitter
Resize = require 'Resize'
config = require('./config.coffee').get()


class DreamAssetLoader extends EventEmitter
	assetTypes = ['people','terms']
	maxTextureSize = 2000
	maxPerDream = config.max

	useImageProxy = true
	useJSResizer = false
	checkLoadStatus: (allowErrors = true) =>
		#console.log @imagesLoaded + ' ' + @imagesErrored + ' / ' + @imagesRequested
		loaded = false
		if allowErrors
			loaded = @imagesLoaded + @imagesErrored is @imagesRequested
		else
			loaded = @imagesLoaded is @imagesRequested
		if loaded
			@emit('loaded')
			@loadMore()

	imageLoadedCallback: () =>
		@imagesLoaded += 1
		@checkLoadStatus(true)
	imageProgressHandler = () ->

	imagesErrorHandler: () =>
		@imagesErrored += 1
		@checkLoadStatus()
	loadImages: (numImagesToLoad) =>
		console.log 'load images ' + numImagesToLoad
		@numRequested = 0
		@numLoaded = 0
		if numImagesToLoad > @data.images.length
			numImagesToLoad = @data.images.length
		_.each(@data.images, (image) =>
			if image.loaded
				return
			if image.loading
				return
			if @numRequested is numImagesToLoad
				return false
			imageLoaded = (texture) =>
				if @checkTextureSize(image,texture, true)
					return
				image.texture = texture
				image.loaded = true
				image.loading = false
				@numLoaded += 1
				@imageLoadedCallback()
			@numRequested += 1
			@imagesRequested += 1
			image.loading = true
			image.originalURL = image.url
			if useImageProxy
				substrPrefixLength = 8
				if image.url.indexOf('https') isnt 0
					substrPrefixLength = 7
				image.url = 'http://' + document.location.hostname + ':5100/' + image.url.substr(substrPrefixLength)
			@textureLoader.load(image.url, imageLoaded, imageProgressHandler, @imagesErrorHandler)
		)
	
	loadMore: () =>
		image = _.find(@data.images, (d) -> ! d.loaded && ! d.loading)
		if not image?
			return
		image.loading = true
		image.originalURL = image.url
		if useImageProxy
			substrPrefixLength = 8
			console.log image.url
			if image.url.indexOf('https') isnt 0
				substrPrefixLength = 7
			image.url = 'http://' + document.location.hostname + ':5100/' + image.url.substr(substrPrefixLength)
		imageLoaded = (texture) =>
			if @checkTextureSize(image, texture, false)
				return
			image.texture = texture
			image.loaded = true
			image.loading = false
			@imagesLoaded += 1
			@emit('moreImages', image)
			if @imagesLoaded < maxPerDream
				@loadMore()	
		#console.log 'load more ' + image.url
		@textureLoader.load(image.url, imageLoaded, imageProgressHandler, @loadMore)



	loadingProgress = (e) ->
		console.log e
	loadInitial: (numToLoad) =>
		console.log @data
		@loadImages(numToLoad)

	checkTextureSize: (image,texture, loadingInitial) ->
		console.log arguments
		img = texture.image
		if img.width > maxTextureSize or img.height > maxTextureSize
			widthIsLargerThanHeight = img.width > img.height
			widthToHeight = img.width / img.height
			resizedDimensions = {}
			resizeSize = 400
			if widthIsLargerThanHeight
				resizedDimensions.w = resizeSize
				resizedDimensions.h = (1 / widthToHeight) * resizeSize
			else
				resizedDimensions.h = resizeSize
				resizedDimensions.w = widthToHeight * resizeSize
			console.log 'resizing to'
			console.log resizedDimensions
			if useJSResizer
				resizedCallback = (data) =>
					console.log 'resized'
					texture.img = data
					image.texture = texture
					image.loaded = true
					image.loading = false
					@numLoaded += 1
					if loadingInitial
						@imageLoadedCallback()
					else
						@emit('moreImages', image)
						if @imagesLoaded < maxPerDream
							@loadMore()	
				
				resized = new Resize(img.width, img.height, 
					~~resizedDimensions.w, ~~resizedDimensions.h, 
					true, true, true, resizedCallback, true)
				resized.resizeImage(img)
				return true
			else
				substrPrefixLength = 8
				if image.originalURL.indexOf('https') isnt 0
					substrPrefixLength = 7

				resizeURL = 'http://' + document.location.hostname + ':3000/?w=' + ~~resizedDimensions.w + 
					"&h=" + ~~resizedDimensions.h + "&u=http://" + image.originalURL.substr(substrPrefixLength)
				console.log resizeURL
				image.url = resizeURL
				if loadingInitial
					@textureLoader.load(image.url, (texture) =>
						image.texture = texture
						image.loaded = true
						image.loading = false
						@numLoaded += 1
						@imageLoadedCallback()
					, imageProgressHandler, @imagesErrorHandler)
				else
					@textureLoader.load(image.url, (texture) =>
						image.texture = texture
						image.loaded = true
						image.loading = false
						@imagesLoaded += 1
						@emit('moreImages', image)
						if @imagesLoaded < maxPerDream
							@loadMore()	
					, imageProgressHandler, @loadMore)

				return true	
		return false
	constructor: (@data) ->
		@assets = {}
		@textureLoader = null
		@imagesLoaded = 0
		@imagesRequested = 0
		@imagesErrored = 0
		
		@textureLoader = new THREE.TextureLoader()
		if useImageProxy
			@textureLoader.crossOrigin = true
		console.log @data
		d3.shuffle(@data.images)

module.exports = DreamAssetLoader