EventEmitter = require('events').EventEmitter
exports = new EventEmitter()

exports.requestDreams = () ->

exports.getOptions = () ->
	return [
		{ key: "reddit" }
	]
exports.getName = () ->
	return 'reddit'



exports.reddit = () ->
	console.log('reddit')
module.exports = exports
