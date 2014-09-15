d3 = require('d3')
_ = require('lodash')
EventEmitter = require('events').EventEmitter
dreamManager = require('../dreamManager.coffee')

exports = new EventEmitter()
source = '/testdata'
dreams = null
exports.requestDreams = () ->
	d3.json(source, loadData)
exports.getOptions = () ->
	return []
exports.getName = () ->
	return 'test data'

loadData = (err, _dreams) ->
	dreams = [
		{
			images: _dreams
		}
	]

	dreamManager.addDreams(dreams)


exports.next = () ->
	console.log('next')
	dreamManager.next()
module.exports = exports
