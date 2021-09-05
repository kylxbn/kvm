extends GPU
class_name X1

var _buffer: PoolByteArray

const _WIDTH = 640
const _HEIGHT = 480

var _ram: PoolByteArray

func _init():
	_buffer = PoolByteArray()
	_buffer.resize(_WIDTH * _HEIGHT * 4)
	for i in 640 * 480:
		_buffer.set(i * 4 + 3, 255)
		
	_ram = PoolByteArray()
	_ram.resize(16)
		
func _set_pixel(x: int, y: int, color: Color):
	var index = 4 * (y * _WIDTH + x)
	_buffer.set(index, color.r8)
	_buffer.set(index + 1, color.g8)
	_buffer.set(index + 2, color.b8)
	_buffer.set(index + 3, color.a8)

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
		_set_pixel(int(x), int(y), color)
		x += dx
		y += dy
		i += 1

func get_image():
	var image = Image.new()
	image.create_from_data(640, 480, false, Image.FORMAT_RGBA8, _buffer)
	return image

func set_at(index: int, val: int):
	if index == 0xF:
		_draw_line()
	else:
		_ram.set(index, val)
