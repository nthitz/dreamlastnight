_ = require('lodash')
THREE = require('threejs')
d3 = require('d3')
EventEmitter = require('events').EventEmitter
class DreamAssetLoader extends EventEmitter
	assetTypes = ['people','terms']
	assets = {}
	loadingManager = null
	textureLoader = null
	allLoadingCallback = null
	loadPeople = () ->
		return
		console.log 'load people'
		console.log @
		_.each(@data.people, (person, personIndex) ->
			avatarTextureLoaded = (texture) ->
				console.log texture
				person.avatarTexture = texture
				person.loaded = true
			console.log textureLoader
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
			numRequested += 1
			termImage.loading = true
			termImage.url = 'http://localhost:5100/' + termImage.url.substr(8)
			textureLoader.load(termImage.url, termImageLoaded)
		)

	loadingDone = () ->
		console.log 'loading done called'
		if allLoadingCallback?
			allLoadingCallback()
	loadingProgress = () ->
	 
	loadInitialCallback = () ->
		console.log 'all loaded'
		console.log @data.people[0].avatarTexture
		console.log @data.termImages[0]
		@emit('loaded')
	loadInitial: (num) =>
		console.log @data

		allLoadingCallback = loadInitialCallback
		loadTerms(num)
		loadPeople()


	constructor: (@data) ->

		loadPeople = loadPeople.bind( @ )
		loadTerms = loadTerms.bind( @ )
		loadInitialCallback = loadInitialCallback.bind( @ )

		loadingManager = new THREE.LoadingManager(loadingDone, loadingProgress)
		textureLoader = new THREE.TextureLoader(loadingManager)
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