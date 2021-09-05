extends Object
class_name RAM

var _size: int
var _data: PoolByteArray

var _devices: Array

func _init(size: int):
	_size = size
	
	_data = PoolByteArray()
	_data.resize(_size)
	
func _in_devices(index):
	var size = _devices.size()
	if size == 0:
		return -1

	if _devices[0][0] > index || _devices[size-1][1] < index:
		return -1

	for device_index in range(_devices.size()):
		if index >= _devices[device_index][0] and index <= _devices[device_index][1]:
			return device_index
	
	return -1

func get_at(index: int):
	var device_index = _in_devices(index)
	if device_index >= 0:
		var device_data = _devices[device_index]
		return device_data[2].get_at(index - device_data[0])
	else:
		return _data[index]

func set_at(index: int, data: int):
	var device_index = _in_devices(index)
	if device_index >= 0:
		var device_data = _devices[device_index]
		device_data[2].set_at(index - device_data[0], data)
	else:
		_data.set(index, data)

func add_device(device: MemoryMappedDevice, start: int, end: int):
	_devices.append([start, end, device])
