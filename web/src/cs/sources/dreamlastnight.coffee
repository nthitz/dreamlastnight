d3 = require('d3')
_ = require('lodash')
EventEmitter = require('events').EventEmitter
dreamManager = require('../dreamManager.coffee')

exports = new EventEmitter()
source = '/dreamdata'
dreams = null


setupDreamImages = (dream) ->
	dream.images = []
	_.each(dream.terms, (term) ->
		_.each(term.images, (termImage) ->
			dream.images.push( termImage.url )
		)
	)
loadData = (err, _dreams, cb) ->

	dreams = _dreams
	_.each(dreams, setupDreamImages)
	if cb?
		cb(dreams)
	#dreamManager.addDreams(dreams)


next = () ->
	console.log('next')
	dreamManager.next()



options = {
	"next": next
}

exports.requestDreams = (cb) ->
	d3.json(source, (err, data) -> loadData(err, data, cb))
exports.getName = () ->
	return 'dream last night'
exports.initGUI = (folder) ->
	console.log options
	folder.add(options, 'next')
module.exports = exports
