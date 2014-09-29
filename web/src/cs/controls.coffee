d3 = require 'd3'
ee = require 'EventEmitter'
dat = require 'dat'
_ = require 'lodash'
$ = require 'jquery'

dreamManager = require './dreamManager.coffee'
gui = new dat.GUI()
window.gui = gui
exports = new ee()

typeNames = ['dreamlastnight']

sources = [
	require './sources/reddit.coffee'
	#require './sources/testdata.coffee'
	#require './sources/dreamlastnight.coffee'
	#require './sources/twitter.coffee'


]

controls = d3.select('body').append('div').attr('class','controls')

options = {
	source: sources[0]
}

gui.add(options, 'source', _.map(sources, (d) -> return d.getName()) )
	.onFinishChange( (value) ->
		options.source = _.filter(sources, (d) -> return d.getName() is value)[0]
		showHideSourceFolderOptions(options.source)
		options.source.requestDreams(dreamManager.newDreams)
	)

_.each(sources, (source, sourceIndex) ->
	f = gui.addFolder(source.getName())
	if source.initGUI?
		source.initGUI(f)

)

showHideSourceFolderOptions = (source) ->
	sourceName = source.getName();
	controls.selectAll('li.folder').style('display','none')
	sourceTitle = $(controls[0][0]).find('li.folder .dg .title:contains("' + sourceName + '")')
	console.log(sourceTitle)
	folder = sourceTitle.parents('.folder')
	folder.show()
	folder.find('ul').removeClass('closed')

# https://groups.google.com/d/msg/d3-js/AsbOTQskipU/aEsEozMkDMIJ
controls.select(() ->
    return this.appendChild(gui.domElement);
)

showHideSourceFolderOptions(options.source)


exports.getSource = () ->
	console.log(options.source)
	return options.source

module.exports = exports