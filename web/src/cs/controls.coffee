d3 = require 'd3'
ee = require 'EventEmitter'
dat = require 'dat'
_ = require 'lodash'

dreamManager = require './dreamManager.coffee'
console.log(dat)
gui = new dat.GUI()
window.gui = gui

exports = new ee()

types = [
			{ 
				name: "dream last night"
				options: [ 
					{ key: "next" }
				]
				next: () ->
					console.log 'next'
			},
			{ 
				name: "subreddit"
			},
			{
				name: "twitter"
			}
		]
options = {
	type: types[0],
}

gui.add(options, 'type', _.map(types, (d) -> return d.name ))
_.each(types, (type, typeIndex) ->
	f = gui.addFolder(type.name)
	if type.options?
		_.each(type.options, (opt) ->
			f.add(type, opt.key)
		)
)
controls = d3.select('body').append('div').attr('class','controls')
console.log(gui.domElement)
controls.select(() ->
    return this.appendChild(gui.domElement);
)

#gui.

module.exports = exports