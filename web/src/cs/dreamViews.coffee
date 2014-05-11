_ = require 'lodash'
views = [
	{ name: 'default', view: require './views/default.coffee' }
]
applyView = (viewName, data, scene) ->
	view = _.find(views, (view) -> view.name is viewName)
	view.view.initView(data, scene)

init = () ->

init()
exports = {
	views: views,
	applyView: applyView
}

module.exports = exports