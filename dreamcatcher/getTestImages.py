import urllib
import os
f = open('data/imgur_image_list.txt')
imageList = f.readlines()
f.close()
dir = "testImages/"
if not os.path.exists(dir):
    os.makedirs(dir)
for image in imageList:
	image = image.strip()
	slash = image.rfind('/')
	print image
	saveName = image[slash + 1:]
	print saveName
	urllib.urlretrieve(image, dir + saveName)