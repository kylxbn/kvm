extends MemoryMappedDevice
class_name GPU

var _image: Image
var changed: bool

func _init():
	_image = Image.new()
	_image.create(640, 480, false, Image.FORMAT_RGBA8)
	changed = false

func get_image():
	return _image

func set_at(index: int, val: int):
	pass

func reset():
	pass
