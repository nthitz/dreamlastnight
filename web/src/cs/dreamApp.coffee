THREE = require('threejs')
Stats = require('Stats')
d3 = require 'd3'
_ = require('lodash')
TrackballControls = require('TrackballControls')
CSS3DRenderer = require('CSS3DRenderer')
require('browsernizr/test/css/transforms3d');
m = require('browsernizr');



controls = require './controls.coffee'
debug = require('./debugView.coffee')
manager = require('./dreamManager.coffee')
config = require('./config.coffee').get()
scene = null
renderer = null
camera = null
cameraControls = null
stats = null
useTestData = false
testImages = []
init = () ->
	console.log JSON.stringify(config)
	
	createScene()
	manager.init(scene, camera)

	window.d3 = d3
	window._ = _
	window.THREE = THREE

	controls.getType().requestDreams()

	animate()

randomTestImage = () ->
	random = _.sample(testImages)
	return random
###
dreamsDreamt = (dreamsData) ->
	console.log 'loaded'
	if useTestData
		# TODO load test data via a new source
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
	window.debug = debug.toggle
###
onWindowResize = () ->
	camera.aspect = window.innerWidth / window.innerHeight;
	camera.updateProjectionMatrix();
	renderer.setSize( window.innerWidth, window.innerHeight );
createScene = () ->
	
	renderer = new THREE.CSS3DRenderer()
	renderer.setClearColor(0x000000,1)
	renderer.setSize(window.innerWidth, window.innerHeight)
	document.body.appendChild(renderer.domElement)
	renderer.domElement.style.cursor = 'none'
	stats = new Stats()
	stats.domElement.style.position	= 'absolute';
	stats.domElement.style.bottom	= '0px';
	stats.domElement.style.right	= '0px';

	document.body.appendChild( stats.domElement );

	scene = new THREE.Scene()

	
	camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 3000)
	camera.position.set(0,0, -10)
	scene.add camera

	window.addEventListener( 'resize', _.throttle(onWindowResize,100), false );
		
animate = () ->
	requestAnimationFrame(animate)
	manager.update()
	render()
	stats.update()
render = () ->
	#cameraControls.update()
	renderer.render(scene, camera)

if m.csstransforms3d
	init()
else
	alert 'you\'ll need to upgrade your browser to view this'