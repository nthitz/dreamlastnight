THREE = require('threejs')
Stats = require('Stats')
d3 = require 'd3'
_ = require('lodash')
TrackballControls = require('TrackballControls')

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
init = () ->
	dataLoader.on('loaded', dreamsDreamt)
	window.d3 = d3
	window._ = _
	window.THREE = THREE
dreamsDreamt = (dreamsData) ->
	console.log 'loaded'
	console.log dreams
	console.log THREE
	
	console.log debug
	debug.initDebug(dreamsData)

	createScene()

	dreams.init(dreamsData, scene)

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

	cameraControls = new THREE.TrackballControls(camera)
animate = () ->
	requestAnimationFrame(animate)
	render()
	stats.update()
render = () ->
	cameraControls.update()
	renderer.render(scene, camera)

init()