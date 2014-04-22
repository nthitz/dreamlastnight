d3 = require('d3')
showDebug = (dreams) ->
	console.log 'debug'
	debug = d3.select('body').append('div').attr('class','debug')
	#dreamDiv = debug.selectAll('div.dream').data(dreams)
	#dreamDiv.enter().append('div').attr('class','dream')

exports = {
	showDebug:showDebug
}
module.exports = exports