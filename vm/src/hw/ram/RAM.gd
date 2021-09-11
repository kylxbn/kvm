extends MemoryMappedDevice
class_name RAM

var _size: int
var _data: PoolByteArray

func _init(size: int):
	_size = size
	
	_data = PoolByteArray()
	_data.resize(_size)
	
func get_at(index: int):
	return _data[index]

func set_at(index: int, data: int):
	_data.set(index, data)

func reset():
	_data = PoolByteArray()
	_data.resize(_size)
