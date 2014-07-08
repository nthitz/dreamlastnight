_ = require('lodash')
d3 = require 'd3'

Dream = require('./dream.coffee')
controls = require './controls.coffee'
dreams = []
scene = null
camera = null
curDream = null
initDreams = (dreamsData, _scene, _camera) ->
	scene = _scene
	camera = _camera
	_.each(dreamsData,(dreamData) =>
		dreams.push new Dream(dreamData, scene, camera)
	)
	dreams = _.shuffle(dreams)
	curDream = _.find(dreams, (d) ->
		console.log d
		numImages = d3.sum(d.dreamData.terms, (t) ->
			return t.images.length
		)
		return numImages > 20
	)
	curDream.loadInitial()
	_.defer(() ->
		console.log curDream
	)
getCurDream = () ->
	return curDream
update = () ->
	curDream.update()
exports = {
	init: initDreams
	update: update
	curDream: getCurDream
}
console.log exports
module.exports = exports