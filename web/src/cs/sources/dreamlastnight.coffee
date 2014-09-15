d3 = require('d3')
_ = require('lodash')
EventEmitter = require('events').EventEmitter
dreamManager = require('../dreamManager.coffee')

exports = new EventEmitter()
source = '/dreamdata'
dreams = null
exports.requestDreams = () ->
	d3.json(source, loadData)
exports.getOptions = () ->
	return [
		{ key: "next" }
	]
exports.getName = () ->
	return 'dream last night'

setupDreamImages = (dream) ->
	dream.images = []
	_.each(dream.terms, (term) ->
		_.each(term.images, (termImage) ->
			dream.images.push( termImage.url )
		)
	)
loadData = (err, _dreams) ->

	dreams = _dreams
	_.each(dreams, setupDreamImages)
	dreamManager.addDreams(dreams)


exports.next = () ->
	console.log('next')
	dreamManager.next()
module.exports = exports
