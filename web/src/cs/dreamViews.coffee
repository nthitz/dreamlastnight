_ = require 'lodash'
THREE = require('threejs')
views = [
	{ name: 'default', view: require './views/default.coffee' }
]
curView = null
applyView = (viewName, assets, scene, camera) ->
	view = _.find(views, (view) -> view.name is viewName)
	curView = view
	view.view.initView(assets, scene, camera)

updateView = () ->
	if curView?
		curView.view.update()
init = () ->

init()
exports = {
	views: views,
	applyView: applyView
	updateView: updateView
}

module.exports = exports