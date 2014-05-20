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
	curDream = dreams[0]
	curDream.loadInitial()
update = () ->
	curDream.update()
exports = {
	init: initDreams
	update: update
}
console.log exports
module.exports = exports