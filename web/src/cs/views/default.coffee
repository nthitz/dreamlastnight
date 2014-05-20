d3 = require 'd3'
THREE = require 'threejs'
CSS3DRenderer = require 'CSS3DRenderer'
TWEEN = require 'tween'
data = null
assets = null
scene = null
camera = null

sprites = []
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
		
		img = image.texture.image

		imageDimensions = {w: image.texture.image.width, h: image.texture.image.height}
		size = 400
		ratio = imageDimensions.w / imageDimensions.h
		spriteDimensions = {}
		if imageDimensions.w > imageDimensions.h
			spriteDimensions.w = size
			spriteDimensions.h = (1 / ratio) * size
		else
			spriteDimensions.h = size
			spriteDimensions.w = ratio * size
		
		img.style.width = spriteDimensions.w + 'px'
		img.style.height = spriteDimensions.h + 'px'



		sp = new THREE.CSS3DObject(img)
		sp.scale.setX(-1)
		range = 1000
		xRange = d3.scale.linear().range([-range, range])
		yRange = d3.scale.linear().range([-range, range])
		range = 2000
		zRange = d3.scale.linear().range([0, range])


		sp.position.set( xRange(Math.random()), yRange(Math.random()), zRange(Math.random()) )
		sprites.push(sp)

		scene.add(sp)
	)
	document.addEventListener('mousewheel', (scrollEvent) -> 
		move( scrollEvent.wheelDelta ) 
	, false) 
move = (amount) ->
	_.each(sprites, (sprite) ->
		sprite.position.z -= amount
		if sprite.position.z < -10
			sprite.position.z += 3000
		else if sprite.position.z > 3000
			sprite.position.z -= 3000 + 10
	)
update = () ->
	move(10)
	#camera.rotation.x += 0.01
	#camera.rotation.z += 0.001
	camera.updateMatrix()
	TWEEN.update()

module.exports = {
	initView: initView,
	update: update
}