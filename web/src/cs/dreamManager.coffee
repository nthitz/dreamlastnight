_ = require('lodash')
Dream = require('./dream.coffee')
dreams = []
scene = null
initDreams = (dreamsData, _scene) ->
	scene = _scene
	_.each(dreamsData,(dreamData) =>
		dreams.push new Dream(dreamData, scene)
	)
	dreams[0].loadInitial()
exports = {
	init: initDreams
}
module.exports = exports