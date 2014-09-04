d3 = require 'd3'
ee = require 'EventEmitter'
dat = require 'dat'
_ = require 'lodash'

dreamManager = require './dreamManager.coffee'
gui = new dat.GUI()
window.gui = gui
exports = new ee()
typeNames = ['dreamlastnight']
console.trace()
types = [
	require './sources/dreamlastnight.coffee'
	require './sources/reddit.coffee'
	require './sources/twitter.coffee'


]
console.log(types)

options = {
	type: types[0]
}

gui.add(options, 'type', _.map(types, (d) -> return d.getName() ))
_.each(types, (type, typeIndex) ->
	f = gui.addFolder(type.getName())
	if type.getOptions()?
		_.each(type.getOptions(), (opt) ->
			f.add(type, opt.key)
		)
)
controls = d3.select('body').append('div').attr('class','controls')
console.log(gui.domElement)
controls.select(() ->
    return this.appendChild(gui.domElement);
)
exports.getType = () ->
	console.log(options.type)
	return options.type

module.exports = exports