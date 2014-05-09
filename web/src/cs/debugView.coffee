d3 = require('d3')
debug = null
initDebug = (dreams) ->
	console.log 'debug'
	debug = d3.select('body').append('div').attr('class','debug').style('display','none')
	dreamDiv = debug.selectAll('div.dream').data(dreams)
	enteringDiv = dreamDiv.enter().append('div').attr('class','dream')
	enteringDiv.append('div').attr('class','text')
	dreamDiv.selectAll('.text').html((d) -> return d.embed_html)
	enteringDiv.append('div').attr('class', 'people')
	enteringDiv.append('div').attr('class', 'terms')
	enteringDiv.append('hr')
	peopleDivs = dreamDiv.selectAll('.people').selectAll('.person').data((d) -> return d.people)
	peopleEnter = peopleDivs.enter().append('div').attr('class','person')
	peopleEnter.append('img').attr('src',(d) -> return d.profile_image_url_https)
	peopleEnter.append('span').text((d) -> return d.screen_name)
	peopleEnter.append('span').text((d) -> return d.relationship)



	termDivs = dreamDiv.selectAll('.terms').selectAll('.term').data((d) -> return d.terms)
	termEnter = termDivs.enter().append('div').attr('class','term')
	termEnter.append('div').text((d) -> return d.term.term)
	termEnter.append('div').attr('class','images empty')
	termDivs.on('click', () ->
		console.log this
		imageDiv = d3.select(this).select('.images')
		if imageDiv.classed('empty')
			images = imageDiv.selectAll('.image').data((d) -> return d.images)
			images.enter().append('img').attr('src',(d) -> return d.url)
			imageDiv.classed('empty',false).classed('open', true)
		else
			open = imageDiv.classed('open')
			if open
				imageDiv.classed('open', false).classed('closed', true)
			else
				imageDiv.classed('open', true).classed('closed', false)
	)

toggle = () ->
	debug.style('display','block')

exports = {
	initDebug:initDebug,
	toggle: toggle
}
module.exports = exports
