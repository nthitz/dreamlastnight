html = null
tweet = null
div = null
initText = (_tweet) ->
	tweet = _tweet
	html = tweet.embed_html
	div = d3.selectAll('.tweetText').data([tweet])
	divEnter = div.enter()
	divEnter.append('div').attr('class','tweetText')
	console.log html
	div.html(html)
	console.log tweet

show = () ->

hide = () ->

exports = {
	init: initText,
	show: show,
	hide:hide
}

module.exports = exports