d3 = require 'd3'
THREE = require 'threejs'
CSS3DRenderer = require 'CSS3DRenderer'

data = null
assets = null
scene = null
camera = null

initView = (_assets, _scene, _camera) ->
	assets = _assets
	scene = _scene
	camera = _camera
	console.log 'init view'
	data = assets.data
	loadedImages = _.select(data.termImages, (image) -> 
		return image.loaded
	)
	planeGeom = new THREE.PlaneGeometry(10,10)
	_.each(loadedImages, (image,index) ->
		console.log image.texture.image
		
		img = image.texture.image
		img.style.width = image.texture.image.width + 'px'
		img.style.height = image.texture.image.height + 'px'


		sp = new THREE.CSS3DObject(img)
		range = 8000
		xRange = d3.scale.linear().range([-range, range])
		yRange = d3.scale.linear().range([-range, range])
		zRange = d3.scale.linear().range([-range, range])


		sp.position.set( xRange(Math.random()), yRange(Math.random()), zRange(Math.random()) )
		
		scene.add(sp)
	)
update = () ->
	camera.rotation.x += 0.01
	camera.rotation.z += 0.001
	camera.updateMatrix()

module.exports = {
	initView: initView,
	update: update
}