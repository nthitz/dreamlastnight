d3 = require('d3')
$ = require('jquery')
jquery = require('jquery')
jqtree = require('jqtree')
showDebug = (dreams) ->
	console.log 'debug'
	debug = d3.select('body').append('div').attr('class','debug')
	#dreamDiv = debug.selectAll('div.dream').data(dreams)
	#dreamDiv.enter().append('div').attr('class','dream')
	$('.debug').tree({
		data: dreams
	})
exports = {
	showDebug:showDebug
}
module.exports = exports