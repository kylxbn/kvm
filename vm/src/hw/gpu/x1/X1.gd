extends GPU
class_name X1

var _buffer: Image

const _WIDTH = 256
const _HEIGHT = 256

var _ram: PoolByteArray

func _init():
	_buffer = Image.new()
	_buffer.create(_WIDTH, _HEIGHT, false, Image.FORMAT_RGB8)
		
	_ram = PoolByteArray()
	_ram.resize(16)
	
	changed = false
		
func _set_pixel(x: int, y: int, color: Color):
	_buffer.set_pixel(x, y, color)

func _draw_line():
	var x1 = _ram[0]
	var y1 = _ram[1]
	var x2 = _ram[2]
	var y2 = _ram[3]
	
	var color = Color8(_ram[4], _ram[5], _ram[6])
	
	var dx: float = x2 - x1
	var dy: float = y2 - y1
	var step: float = 0
	if abs(dx) >= abs(dy):
		step = abs(dx)
	else:
		step = abs(dy)
		
	dx /= step
	dy /= step
	
	var x: float = x1
	var y: float = y1
	var i: int = 1

	while i <= step:
		_buffer.set_pixel(int(x), int(y), color)
		x += dx
		y += dy
		i += 1
	
	changed = true

func get_image():
	changed = false
	return _buffer

func set_at(index: int, val: int):
	if index == 0xF:
		_buffer.lock()
		_draw_line()
		_buffer.unlock()
	else:
		_ram.set(index, val)

func reset():
	_buffer = Image.new()
	_buffer.create(_WIDTH, _HEIGHT, false, Image.FORMAT_RGB8)
		
	_ram = PoolByteArray()
	_ram.resize(16)
	
	changed = true
