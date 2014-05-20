THREE = require('threejs')
Stats = require('Stats')
d3 = require 'd3'
_ = require('lodash')
TrackballControls = require('TrackballControls')
CSS3DRenderer = require('CSS3DRenderer')

dataLoader = require('./dataLoader.coffee')
debug = require('./debugView.coffee')
dreams = require('./dreamManager.coffee')

scene = null
renderer = null
camera = null
cameraControls = null
stats = null
console.log TrackballControls
console.log THREE
useTestData = true
testImages = []
init = () ->
	dataLoader.on('loaded', dreamsDreamt)
	window.d3 = d3
	window._ = _
	window.THREE = THREE
randomTestImage = () ->
	random = _.sample(testImages)
	return random
dreamsDreamt = (dreamsData) ->
	console.log 'loaded'
	if useTestData
		testImages = dreamsData.testImages
		_.each(dreamsData.dreams, (dream) ->
			_.each(dream.people, (person) ->
				person.profile_image_url_https = randomTestImage()
			)
			_.each(dream.terms, (term) ->
				_.each(term.images, (termImage) ->
					termImage.url = randomTestImage()
				)	
			)
		)
	debug.initDebug(dreamsData.dreams)


	createScene()

	dreams.init(dreamsData.dreams, scene, camera)
	console.log dreams
	animate()

createScene = () ->
	renderer = new THREE.CSS3DRenderer()
	renderer.setClearColor(0x000000,1)
	renderer.setSize(window.innerWidth, window.innerHeight)
	document.body.appendChild(renderer.domElement)
	
	stats = new Stats()
	stats.domElement.style.position	= 'absolute';
	stats.domElement.style.bottom	= '0px';
	document.body.appendChild( stats.domElement );

	scene = new THREE.Scene()

	scene.fog = new THREE.FogExp2(0xff0000, 0.04)

	camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 3000)
	camera.position.set(0,0, 0)
	scene.add camera

	cameraControls = new THREE.TrackballControls(camera)
animate = () ->
	requestAnimationFrame(animate)
	dreams.update()
	render()
	stats.update()
render = () ->
	#cameraControls.update()
	renderer.render(scene, camera)

init()