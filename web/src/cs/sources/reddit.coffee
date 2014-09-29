$ = require('jquery')
EventEmitter = require('events').EventEmitter
exports = new EventEmitter()
dreamManager = require '../dreamManager.coffee'
subs = [
	'aww',
	'pics',
	'foodporn',
	'seinfeld',
	'gifs',
	'perfectloops',
	'woahdude',
	'earthporn',
	'gunners'
]
options = {
	subreddit: subs[0]
}
validDomains = [ 'i.imgur.com', 'imgur.com' ]
urlRewrites = {
	'imgur.com': (url) ->
		u = new URL(url)
		if u.pathname.indexOf('/a/') isnt -1
			return
		return u.protocol + "//" + "i." + u.host + u.pathname + '.png'
}

loadData = (data, cb) ->
	console.log(data)
	if typeof cb is 'undefined'
		console.error 'no callback defined'
		return
	dream = [
		{images: []}
	]
	console.log(data.data.children)
	_.each(data.data.children, (link, linkIndex) ->
		domain = link.data.domain

		if validDomains.indexOf(domain) is -1
			return
		url = link.data.url
		if urlRewrites[domain]?
			url = urlRewrites[domain](url)
		if typeof url isnt 'undefined'
			dream[0].images.push(url)
	)
	console.log dream
	cb(dream)
	
exports.requestDreams = requestDreams = (cb) ->
	url = "http://reddit.com/r/" + options.subreddit + ".json?jsonp=?"
	$.getJSON(url, (data) -> loadData(data, cb))

exports.getName = () ->
	return 'reddit'

exports.initGUI = (folder) ->
	folder.add(options, 'subreddit', subs).onFinishChange( (newOption) ->
		requestDreams(dreamManager.newDreams)
	)
module.exports = exports
