_ = require('lodash')
d3 = require 'd3'

Dream = require('./dream.coffee')
views = require('./dreamViews.coffee')

dreams = []
eligibleDreams = null
scene = null
camera = null
curDream = null
dreamsShown = 0
curView = null
init = (_scene, _camera) ->
	scene = _scene
	camera = _camera
	dreams.length = 0
	_.each(views, (view) ->
		view.view.initView(scene, camera)
	)

dreamIsEligibleFilter = (d) ->
	numImages = d.dreamData.images.length
	return numImages > 10

addDreams = (dreamsData) ->
	console.log('add dreams')
	console.log dreamsData
	_.each(dreamsData,(dreamData) =>
		dreams.push new Dream(dreamData)
	)
	dreams = _.shuffle(dreams)
	eligibleDreams = _.filter(dreams, dreamIsEligibleFilter)
	curDream = eligibleDreams[dreamsShown]
	curDream.loadInitial()
	curDream.on('loaded', dreamsLoaded)
	dreamsShown += 1
newDreams = (dreamsData) ->
	_.shuffle(dreamsData)
	nextDreams = []
	_.each(dreamsData,(dreamData) =>
		nextDreams.push new Dream(dreamData)
	)
	nextEligible = _.filter(nextDreams, dreamIsEligibleFilter)
	nextDream = nextEligible[0]
	nextDream.loadInitial()
	nextDream.on('loaded', (assets) ->
		console.log 'next dream loaded'
		console.log(curDream)
		curView.view.transitionOut(() ->
			dreamsLoaded(assets)
			curDream = nextDream
			eligibleDreams = nextEligible
			dreams = nextDream
			dreamsShown = 1
		)
	)

	#cur dream fade out

	#callback of fade out 
	# ->
	#	apply view of new dream
dreamsLoaded = (assets) ->
	applyView('default', assets)
applyView = (viewName, assets) ->
	curView = _.find(views, (view) -> view.name is viewName)
	curView.view.addAssets(assets)
	
getCurDream = () ->
	return curDream
update = () ->
	if curView isnt null
		curView.view.update()
resize = () ->
	if curView isnt null
		curView.view.resize()

next = () ->
	nextDream = eligibleDreams[dreamsShown]
	dreamsShown += 1
	nextDream.loadInitial()
	nextDream.on('loaded', (assets) ->
		console.log 'next dream loaded'
		console.log(curDream)
		curView.view.transitionOut(() ->
			dreamsLoaded(assets)
			curDream = nextDream
		)
	)

exports = {
	init: init
	addDreams: addDreams
	newDreams: newDreams
	update: update
	curDream: getCurDream
	next: next
	resize: resize
}
console.log exports
module.exports = exports