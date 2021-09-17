extends HDD
class_name GenericHDD

var _high: int = 0;
var _low: int = 0;

func _init().():
	pass

func _read():
	_disk.seek(_high << 8 + _low)
	for i in 512:
		_ram.set(i, _disk.get_8() if not _disk.eof_reached() else 0)

func _write():
	_disk.seek(_high << 8 + _low)
	for i in 512:
		_disk.store_8(_ram[i])

func set_at(index: int, val: int):
	if index == 0x200:
		_high = val
	elif index == 0x201:
		_low = val
	elif index == 0x202:
		if val == 0:
			_read()
		elif val == 1:
			_write()

func get_at(index: int):
	if index < 0x200:
		return _ram[index]
	elif index == 0x201:
		return _high
	elif index == 0x202:
		return _low
	else:
		return 0

