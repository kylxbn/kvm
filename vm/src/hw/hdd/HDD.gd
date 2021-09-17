extends MemoryMappedDevice
class_name HDD

var _ram: PoolByteArray
var _disk: File

func _init():
	_ram = PoolByteArray()
	_ram.resize(512)
	
func set_file(f: File):
	if _disk != null:
		close_file()

	_disk = f

func close_file():
	if _disk.is_open():
		_disk.close()	

func set_at(index: int, val: int):
	pass

func get_at(index: int):
	pass
