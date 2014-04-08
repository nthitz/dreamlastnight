EventEmitter = require('events').EventEmitter
d3 = require('d3')
exports = new EventEmitter()
source = '/dreamdata'
dreams = null
init = () ->
	d3.json(source, loadData)
loadData = (err, _dreams) ->
	dreams = _dreams
	exports.emit('loaded', dreams)
getDreams = () ->
	return dreams

init()

exports.getDreams = getDreams
module.exports = exports
