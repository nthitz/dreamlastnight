EventEmitter = require('events').EventEmitter
exports = new EventEmitter()

exports.requestDreams = () ->

exports.getOptions = () ->
	return [
		{ key: "twitter" }
	]
exports.getName = () ->
	return 'twitter'



exports.twitter = () ->
	console.log('twitter')
module.exports = exports
