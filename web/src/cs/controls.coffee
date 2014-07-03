d3 = require 'd3'
ee = require 'EventEmitter'
dat = require 'dat'
console.log(dat)
gui = new dat.GUI()
window.gui = gui
types = [ "dream last night", "subreddit", "twitter"]
options = {
	type: types[0],
	next: () ->
}

gui.add(options, 'type', types)
gui.add(options, 'next')
controls = d3.select('body').append('div').attr('class','controls')
console.log(gui.domElement)
controls.select(() ->
    return this.appendChild(gui.domElement);
)

#gui.

exports = new ee()
module.exports = exports