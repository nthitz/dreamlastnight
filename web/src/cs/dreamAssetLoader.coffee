_ = require('lodash')
THREE = require('threejs')
class DreamAssetLoader
	assetTypes = ['people','terms']
	assets = {}
	loadingManager = null
	textureLoader = null
	allLoadingCallback = null
	loadPeople = () ->
		console.log 'load people'
		console.log @
		_.each(@data.people, (person, personIndex) ->
			avatarTextureLoaded = (texture) ->
				console.log texture
				person.avatarTexture = texture
			console.log textureLoader
			textureLoader.load(person.profile_image_url_https, avatarTextureLoaded)
		)
	loadTerms = (numImagesToLoad) ->
		console.log 'load terms'
	

	loadingDone = () ->
		console.log 'loading done called'
		if allLoadingCallback?
			allLoadingCallback()
	loadingProgress = () ->
	 
	loadInitialCallback = () ->
		console.log 'all loaded'
		console.log @data.people[0].avatarTexture
	loadInitial: (num) =>
		console.log @data

		allLoadingCallback = loadInitialCallback
		loadTerms(num)
		loadPeople()

	constructor: (@data) ->

		loadPeople = loadPeople.bind( @ )
		loadInitialCallback = loadInitialCallback.bind( @ )

		loadingManager = new THREE.LoadingManager(loadingDone, loadingProgress)
		textureLoader = new THREE.TextureLoader(loadingManager)
		_.each(assetTypes, (assetType) =>
			assets[assetType] = @data[assetType]

		)

module.exports = DreamAssetLoader