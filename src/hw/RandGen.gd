extends MemoryMappedDevice
class_name RandGen

func _init():
	pass

func set_at(index: int, val: int):
	pass

func get_at(index: int):
	return randi() % 256
