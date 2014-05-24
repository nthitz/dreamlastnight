_ = require('lodash')
THREE = require('threejs')
d3 = require('d3')
EventEmitter = require('events').EventEmitter
class DreamAssetLoader extends EventEmitter
	assetTypes = ['people','terms']
	assets = {}
	textureLoader = null
	imagesLoaded = 0
	imagesRequested = 0
	imagesErrored = 0
	checkLoadStatus = (allowErrors = true) ->
		loaded = false
		if allowErrors
			loaded = imagesLoaded + imagesErrored is imagesRequested
		else
			loaded = imagesLoaded is imagesRequested
		if loaded
			@emit('loaded')

	imageLoadedCallback = () ->
		imagesLoaded += 1
		checkLoadStatus(true)
	imageProgressHandler = () ->

	imagesErrorHandler = () ->
		imagesErrored += 1
		checkLoadStatus()
	loadPeople = () ->
		return
		console.log 'load people'
		console.log @
		_.each(@data.people, (person, personIndex) ->
			avatarTextureLoaded = (texture) ->
				console.log texture
				person.avatarTexture = texture
				person.loaded = true
				imageLoadedCallback()
			console.log textureLoader
			imagesRequested += 1
			textureLoader.load(person.profile_image_url_https, avatarTextureLoaded)
		)
	loadTerms = (numImagesToLoad) ->
		console.log 'load terms'
		numRequested = 0
		numLoaded = 0
		if numImagesToLoad > @data.termImages.length
			numImagesToLoad = @data.termImages.length
		_.each(@data.termImages, (termImage) ->
			if termImage.loaded
				return
			if termImage.loading
				return
			if numRequested is numImagesToLoad
				return false
			termImageLoaded = (texture) ->
				termImage.texture = texture
				termImage.loaded = true
				termImage.loading = false
				numLoaded += 1
				imageLoadedCallback()
			numRequested += 1
			imagesRequested += 1
			termImage.loading = true
			termImage.url = 'http://localhost:5100/' + termImage.url.substr(8)
			textureLoader.load(termImage.url, termImageLoaded, imageProgressHandler, imagesErrorHandler)
		)

	loadingProgress = (e) ->
		console.log e
	loadInitialCallback = () ->
		console.log 'all loaded'
		console.log @data.people[0].avatarTexture
		console.log @data.termImages[0]
		@emit('loaded')
	loadInitial: (num) =>
		console.log @data

		loadTerms(num)
		loadPeople()


	constructor: (@data) ->

		loadPeople = loadPeople.bind( @ )
		loadTerms = loadTerms.bind( @ )
		checkLoadStatus = checkLoadStatus.bind( @ )

		textureLoader = new THREE.TextureLoader()
		textureLoader.setCrossOrigin(true)
		allTermImages = []
		_.each(assetTypes, (assetType) =>
			assets[assetType] = @data[assetType]
			_.each(assets[assetType], (asset) ->
				if assetType is 'people'
					asset.loaded = false
				else if assetType is 'terms'
					_.each(asset.images, (termImage) ->
						termImage.loaded = false
						termImage.loading = false
						termImage.term = asset.term
						allTermImages.push(termImage)
						return true #ugh this is weird behavior but cs
					)
			)
		)
		d3.shuffle(allTermImages)
		@data.termImages = allTermImages

module.exports = DreamAssetLoader