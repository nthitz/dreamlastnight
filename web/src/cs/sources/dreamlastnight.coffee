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


loadData = (err, _dreams) ->

	dreams = _dreams
	#exports.emit('loaded', dreams)
	dreamManager.addDreams(dreams.dreams)


exports.next = () ->
	console.log('next')
	dreamManager.next()
module.exports = exports
