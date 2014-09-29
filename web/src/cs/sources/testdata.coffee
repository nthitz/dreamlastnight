d3 = require('d3')
_ = require('lodash')
EventEmitter = require('events').EventEmitter
dreamManager = require('../dreamManager.coffee')

exports = new EventEmitter()
source = '/testdata'
dreams = null
exports.requestDreams = (cb) ->
	d3.json(source, (err, data) -> loadData(err, data, cb))
exports.getOptions = () ->
	return []
exports.getName = () ->
	return 'test data'

loadData = (err, _dreams, cb) ->
	images = _.map(_dreams, (dream) ->
		return 'http://' + document.location.host + '/' + dream 
	)
	dreams = [
		{
			images: images
		}
	]

	cb(dreams)


exports.next = () ->
	console.log('next')
	dreamManager.next()
module.exports = exports
