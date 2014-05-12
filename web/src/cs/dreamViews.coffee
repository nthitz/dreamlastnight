_ = require 'lodash'
THREE = require('threejs')
views = [
	{ name: 'default', view: require './views/default.coffee' }
]
applyView = (viewName, assets, scene) ->
	view = _.find(views, (view) -> view.name is viewName)
	view.view.initView(assets, scene)


init = () ->

init()
exports = {
	views: views,
	applyView: applyView
}

module.exports = exports