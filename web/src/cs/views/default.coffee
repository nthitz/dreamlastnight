d3 = require 'd3'
THREE = require 'threejs'
CSS3DRenderer = require 'CSS3DRenderer'
TWEEN = require 'tween'

data = null
assets = null
scene = null
camera = null

sprites = []
xRange = null
yRange = null
zRange = null
zDensity = 150 # defines how much z range we want per image
numLoadedImages = 0
overImage = true;
mouse = {x:0.5, y: 0.5}
mouseOver = (e) ->
	overImage = true
mouseOut = () ->
	overImage = false
newImageLoaded = (image) ->
	#console.log 'new image'
	#console.log image
	numLoadedImages += 1

	sp = addImageToScene(image)
	sp.position.z = zDensity * numLoadedImages
	zRange.range([0, zDensity * numLoadedImages])
addImageToScene = (image) ->
	
	img = image.texture.image

	imageDimensions = {w: image.texture.image.width, h: image.texture.image.height}
	size = 400
	ratio = imageDimensions.w / imageDimensions.h
	spriteDimensions = {}
	if imageDimensions.w > imageDimensions.h
		spriteDimensions.w = Math.min(size, imageDimensions.w)
		spriteDimensions.h = (1 / ratio) * spriteDimensions.w
	else
		spriteDimensions.h = Math.min(size, imageDimensions.h)
		spriteDimensions.w = ratio * spriteDimensions.h
	
	img.style.width = spriteDimensions.w + 'px'
	img.style.height = spriteDimensions.h + 'px'



	sp = new THREE.CSS3DObject(img)
	sp.scale.setX(-1)
	range = 700
	xRange = d3.scale.linear().range([-range, range])
	yRange = d3.scale.linear().range([-range, range])
	range = zDensity * numLoadedImages
	zRange = d3.scale.linear().range([0, range])

	y = yRange(Math.random())
	sp.position.set( xRange(Math.random()), y, zRange(Math.random()) )
	
	sprites.push(sp)
	#console.log sp
	scene.add(sp)
	sp.element.addEventListener('mouseover', mouseOver)
	sp.element.addEventListener('mouseout', mouseOut)
	return sp	
initView = (_assets, _scene, _camera) ->
	assets = _assets
	assets.on('moreImages', newImageLoaded)
	scene = _scene
	camera = _camera
	console.log 'init view'
	data = assets.data
	loadedImages = _.select(data.termImages, (image) -> 
		return image.loaded
	)
	numLoadedImages = loadedImages.length
	console.log 'images loaded ' + loadedImages.length + " of " + data.termImages.length
	planeGeom = new THREE.PlaneGeometry(10,10)
	_.each(loadedImages, (i) ->
		addImageToScene(i)
	)
	document.addEventListener('mousewheel', (scrollEvent) -> 
		move( scrollEvent.wheelDelta ) 
		scrollEvent.preventDefault()
		return false
	, false) 
	document.addEventListener('mousemove', mouseMove, false)
	document.addEventListener('touchstart', touchMove, false)
	document.addEventListener('touchmove', touchMove, false)
move = (amount) ->
	_.each(sprites, (sprite) ->
		sprite.position.z -= amount
		cutoff = 100
		if sprite.position.z < cutoff
			sprite.position.z += zRange.range()[1]
			sprite.position.set( xRange(Math.random()), yRange(Math.random()), sprite.position.z )
		else if sprite.position.z > zRange.range()[1] + cutoff
			sprite.position.z -= zRange.range()[1]
			sprite.position.set( xRange(Math.random()), yRange(Math.random()), sprite.position.z )
		

	)
touchMove = (e) ->
	touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];

	mouse.x = touch.pageX / window.innerWidth
	mouse.y = touch.pageY / window.innerHeight


mouseMove = (e) ->
	mouse.x = e.clientX / window.innerWidth
	mouse.y = e.clientY / window.innerHeight
update = () ->
	###
	amount = (1 - (Math.abs(mouse.x - 0.5) + Math.abs(mouse.y - 0.5))) * 20
	if amount < 1
		amount = 1
	amount = ~~amount
	###
	amount = 20
	move(amount)
	camTargetX = -(mouse.x - 0.5) * 50
	camTargetY = -(mouse.y - 0.5) * 50
	camPosTargetX = -(mouse.x - 0.5) * 1000
	camPosTargetY = -(mouse.y - 0.5) * 1000

	camera.position.x = 0
	camera.position.y = 0
	
	dampening = 0.5

	camera.position.x += (camPosTargetX - camera.position.x) * dampening
	camera.position.y += (camPosTargetY - camera.position.y) * dampening
	camera.lookAt(new THREE.Vector3(camTargetX, camTargetY, 1000))
	#camera.lookAt(new THREE.Vector3(camera.position.x, camera.position.y, 100))
	camera.updateMatrix()
	TWEEN.update()

module.exports = {
	initView: initView,
	update: update
}