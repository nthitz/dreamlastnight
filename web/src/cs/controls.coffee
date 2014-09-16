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
sources = [
	require './sources/dreamlastnight.coffee'
	require './sources/testdata.coffee'
	require './sources/reddit.coffee'
	require './sources/twitter.coffee'


]
console.log(sources)

options = {
	source: sources[0]
}
gui.add(options, 'source', _.map(sources, (d) -> return d.getName()) )
	.onFinishChange( (value) ->
		options.source = _.filter(sources, (d) -> return d.getName() is value)[0]
		console.log(options.source)
		options.source.requestDreams(dreamManager.newDreams)
	)
_.each(sources, (source, sourceIndex) ->
	f = gui.addFolder(source.getName())
	if source.getOptions?
		_.each(source.getOptions(), (opt) ->
			f.add(source, opt.key)
		)
)
controls = d3.select('body').append('div').attr('class','controls')
# https://groups.google.com/d/msg/d3-js/AsbOTQskipU/aEsEozMkDMIJ
controls.select(() ->
    return this.appendChild(gui.domElement);
)
exports.getSource = () ->
	console.log(options.source)
	return options.source

module.exports = exports