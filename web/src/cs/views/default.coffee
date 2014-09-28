d3 = require 'd3'
THREE = require 'threejs'
CSS3DRenderer = require 'CSS3DRenderer'
TWEEN = require 'tween'
keymaster = require 'keymaster'

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
minNumImageRange = 10
isMouseDown = false
mouseOver = (e) ->
	overImage = true
mouseOut = () ->
	overImage = false
newImageLoaded = (image) ->
	#console.log 'new image'
	#console.log image
	numLoadedImages += 1
	sp = addImageToScene(image)
	if typeof sp is 'undefined'
		return
	zNewRange = zDensity * Math.max(minNumImageRange, numLoadedImages)
	zRange.range([0, zNewRange])
	sp.position.z = zRange(1)
addImageToScene = (image) ->
	
	img = image.texture.image
	maxTextureSize = 2000
	imageDimensions = {w: image.texture.image.width, h: image.texture.image.height}
	if imageDimensions.w > maxTextureSize or imageDimensions.h > maxTextureSize
		return
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
	img.draggable = false

	sp = new THREE.CSS3DObject(img)
	range = 700
	xRange = d3.scale.linear().range([-range, range])
	yRange = d3.scale.linear().range([-range, range])
	range = zDensity * Math.max(numLoadedImages, minNumImageRange)
	zRange = d3.scale.linear().range([0, range])

	sp.position.set( xRange(Math.random()),  yRange(Math.random()) , zRange(Math.random()) )
	sp.rotation.z = Math.PI * (Math.random() - 0.5) * 0.1
	sp.rotation.y = Math.PI

	sprites.push(sp)
	#console.log sp
	scene.add(sp)
	sp.element.addEventListener('mouseover', mouseOver)
	sp.element.addEventListener('mouseout', mouseOut)
	return sp	
initView = (_scene, _camera) ->
	scene = _scene
	camera = _camera
	planeGeom = new THREE.PlaneGeometry(1,1)
	
	document.addEventListener('mousewheel', (scrollEvent) -> 
		move( scrollEvent.wheelDelta ) 
		scrollEvent.preventDefault()
		return false
	, false) 
	document.addEventListener('mousemove', mouseMove, false)
	document.addEventListener('touchstart', touchMove, false)
	document.addEventListener('touchmove', touchMove, false)
	document.addEventListener('touchstart', touchEnd, false)

	document.addEventListener('mousedown', mouseDown, false)
	document.addEventListener('mouseup', mouseUp, false)
addAssets = (_assets) ->
	assets = _assets
	assets.on('moreImages', newImageLoaded)
	data = assets.data
	loadedImages = _.select(data.images, (image) -> 
		return image.loaded
	)
	numLoadedImages = loadedImages.length
	console.log 'images loaded ' + loadedImages.length + " of " + data.images.length
	_.each(loadedImages, (i) ->
		addImageToScene(i)
	)


move = (amount, ignoreCutoffs = false) ->
	_.each(sprites, (sprite) ->
		sprite.position.z -= amount
		cutoff = 100
		if !ignoreCutoffs
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

	isMouseDown = true;
touchEnd = () ->
	isMouseDown = false
mouseMove = (e) ->
	mouse.x = e.clientX / window.innerWidth
	mouse.y = e.clientY / window.innerHeight

mouseDown = () ->
	isMouseDown = true;
mouseUp = () ->
	isMouseDown = false;
update = () ->
	###
	amount = (1 - (Math.abs(mouse.x - 0.5) + Math.abs(mouse.y - 0.5))) * 20
	if amount < 1
		amount = 1
	amount = ~~amount
	###
	amount = 20
	if keymaster.isPressed(' ') or isMouseDown

		amount = 2
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
transitionOut = (cb) ->
	assets.removeListener('moreImages', newImageLoaded)
	_.each(sprites, (sprite,spriteIndex) ->
		scene.remove(sprite)
	)
	cb()
module.exports = {
	initView: initView,
	addAssets: addAssets,
	update: update,
	transitionOut: transitionOut
}