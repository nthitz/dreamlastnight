d3 = require('d3')
_ = require('lodash')
EventEmitter = require('events').EventEmitter

exports = new EventEmitter()
source = '/dreamdata'
dreams = null
requestDreamsCB = _.noop
exports.requestDreams = (cb) ->
	requestDreamsCB = cb
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
	requestDreamsCB(dreams)


exports.next = () ->
	console.log('next')
module.exports = exports
