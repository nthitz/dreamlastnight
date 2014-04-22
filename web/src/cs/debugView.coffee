d3 = require('d3')
showDebug = (dreams) ->
	console.log 'debug'
	debug = d3.select('body').append('div').attr('class','debug')
	dreamDiv = debug.selectAll('div.dream').data(dreams)
	enteringDiv = dreamDiv.enter().append('div').attr('class','dream')
	enteringDiv.append('div').attr('class','text')
	dreamDiv.selectAll('.text').html((d) -> return d.embed_html)
	enteringDiv.append('div').attr('class','terms')
	termDivs = dreamDiv.selectAll('.terms').selectAll('.term').data((d) -> return d.terms)
	termEnter = termDivs.enter().append('div').attr('class','term')
	termEnter.append('div').text((d) -> return d.term.term)
	termEnter.append('div').attr('class','images')
	console.log 'wat'
	termDivs.on('click', () ->
		console.log this
		images = d3.select(this).selectAll('.images').selectAll('.image').data((d) -> return d.images)
		images.enter().append('img').attr('src',(d) -> return d.url)
	)
exports = {
	showDebug:showDebug
}
module.exports = exports