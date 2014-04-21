dataLoader = require('./dataLoader.coffee')
THREE = require('three')
Stats = require('Stats')
d3 = require 'd3'
_ = require('lodash')

scene = null
renderer = null
camera = null
cameraControls = null
stats = null
init = () ->
	dataLoader.on('loaded', dreamsDreamt)

dreamsDreamt = (dreams) ->
	console.log 'loaded'
	console.log dreams
	console.log THREE
	
	_.each(dreams,(dream) ->
	)

	createScene()
	animate()

createScene = () ->
	renderer = new THREE.WebGLRenderer()
	renderer.setClearColor(0x000000,1)
	renderer.setSize(window.innerWidth, window.innerHeight)
	document.body.appendChild(renderer.domElement)
	
	stats = new Stats()
	stats.domElement.style.position	= 'absolute';
	stats.domElement.style.bottom	= '0px';
	document.body.appendChild( stats.domElement );

	scene = new THREE.Scene()

	camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 3000)
	camera.position.set(0,0,50)
	scene.add camera

	#cameraControls = new THREE.TrackballControls(camera)
animate = () ->
	requestAnimationFrame(animate)
	render()
	stats.update()
render = () ->
	#cameraControls.update()
	renderer.render(scene, camera)

init()