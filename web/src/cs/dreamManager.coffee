_ = require('lodash')
Dream = require('./dream.coffee')
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
	dreamIndex = Math.floor( Math.random() * dreams.length ) 
	#dreamIndex = 15
	curDream = dreams[ dreamIndex ]
	curDream.loadInitial()
	_.defer(() ->
		console.log curDream
	)
update = () ->
	curDream.update()
exports = {
	init: initDreams
	update: update
}
console.log exports
module.exports = exports