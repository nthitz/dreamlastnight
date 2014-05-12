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

	scene.fog = new THREE.FogExp2(0xff0000, 0.04)

	camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 3000)
	camera.position.set(0,0,-2)
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