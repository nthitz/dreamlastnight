_ = require('lodash')
class DreamAssetLoader
	assetTypes = ['people','terms']
	assets = {}
	constructor: (@data) ->
		_.each(assetTypes, (assetType) ->
			assets[assetType] = @data[assetType]
		)
	loadTerms = () ->
		console.log 'load terms'
	loadPeople = () ->
		console.log 'load people'

	loadInitial: (num) ->
		loadTerms(num)
		loadPeople()
module.exports = DreamAssetLoader