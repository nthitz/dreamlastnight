_ = require('lodash')
d3 = require 'd3'

Dream = require('./dream.coffee')
dreams = []
eligibleDreams = null
scene = null
camera = null
curDream = null
dreamsShown = 0
initDreams = (dreamsData, _scene, _camera) ->
	scene = _scene
	camera = _camera
	dreams.length = 0
	_.each(dreamsData,(dreamData) =>
		dreams.push new Dream(dreamData, scene, camera)
	)
	dreams = _.shuffle(dreams)
	eligibleDreams = _.filter(dreams, (d) ->
		numImages = d3.sum(d.dreamData.terms, (t) ->
			return t.images.length
		)
		return numImages > 20
	)
	curDream = eligibleDreams[dreamsShown]
	curDream.loadInitial()
	dreamsShown += 1
	
getCurDream = () ->
	return curDream
update = () ->
	curDream.update()
next = () ->
	nextDream = eligibleDreams[dreamsShown]
	dreamsShown += 1
	nextDream.loadInitial()

exports = {
	init: initDreams
	update: update
	curDream: getCurDream
	next: next
}
console.log exports
module.exports = exports