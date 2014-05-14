data = null
initView = (assets, scene) ->
	console.log 'init view'
	data = assets.data
	loadedImages = _.select(data.termImages, (image) -> 
		return image.loaded
	)
	planeGeom = new THREE.PlaneGeometry(10,10)
	_.each(loadedImages, (image,index) ->
		console.log image.texture
		material = new THREE.SpriteMaterial({ map: image.texture, color: 0xffffff, useScreenCoordinates: false})
		#material = new THREE.MeshBasicMaterial({ color: 0x00ff00, side: THREE.DoubleSide})
		#imageMesh = new THREE.Mesh(planeGeom, material)
		#imageMesh.position.set(0 , 0, -10 * index)
		#scene.add(imageMesh)
		sp = new THREE.Sprite(material)
		sp.position.set(0, index ,0)

		size = 1
		imageDimensions = {w: image.texture.image.width, h: image.texture.image.height}
		ratio = imageDimensions.w / imageDimensions.h
		spriteDimensions = {}
		if imageDimensions.w > imageDimensions.h
			spriteDimensions.w = size
			spriteDimensions.h = (1 / ratio) * size
		else
			spriteDimensions.h = size
			spriteDimensions.w = ratio * size
		sp.scale.set(spriteDimensions.w,spriteDimensions.h,0)
		scene.add(sp)
	)

module.exports = {
	initView: initView
}