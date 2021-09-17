extends CPU

class_name K1

var _pc: int = 0
var _x: int = 0
var _y: int = 0
var _a: int = 0
var _zf: bool = false

const OP_LOAD_A_ABS = 0xA0
const OP_STORE_A_ABS = 0xA1
const OP_LOAD_X_ABS = 0xA2
const OP_STORE_X_ABS = 0xA3
const OP_LOAD_A_IMM = 0xA4
const OP_LOAD_X_IMM = 0xA5

const OP_LOAD_A_REL = 0xA6
const OP_STORE_A_REL = 0xA7

const OP_ADD_IMM = 0xB0
const OP_SUB_IMM = 0xB1
const OP_ADD_X   = 0xB2
const OP_SUB_X   = 0xB3

const OP_Z_JUMP = 0x91
const OP_JUMP   = 0x90

func _init(mmc: MemoryMapper).(mmc):
	_pc = 0
	_x = 0
	_y = 0
	_a = 0
	_zf = false

func step():
	var opcode = _mmc.get_at(_pc)
	var param = _mmc.get_at(_pc + 1) + (_mmc.get_at(_pc + 2) << 8)
	_pc += 3

	if opcode == OP_LOAD_A_ABS:
		_a = _mmc.get_at(param)
		_zf = _a == 0
	elif opcode == OP_STORE_A_ABS:
		_mmc.set_at(param, _a)
	elif opcode == OP_LOAD_X_ABS:
		_x = _mmc.get_at(param)
	elif opcode == OP_STORE_X_ABS:
		_mmc.set_at(param, _x)
	elif opcode == OP_LOAD_A_IMM:
		_a = param & 0xFF
		_zf = _a == 0
		_pc -= 1
	elif opcode == OP_LOAD_X_IMM:
		_x = param & 0xFF
		_pc -= 1
		
	elif opcode == OP_LOAD_A_REL:
		_a = _mmc.get_at(param + _x)
		_zf = _a == 0
	elif opcode == OP_STORE_A_REL:
		_mmc.set_at(param + _x, _a)
		
	elif opcode == OP_SUB_IMM:
		var res = _a - param
		_a = res if res >= 0 else res + 255
		_zf = _a == 0
	elif opcode == OP_ADD_IMM:
		var res = _a + param
		_a = res if res < 256 else res - 256
		_zf = _a == 0
	elif opcode == OP_SUB_X:
		_pc -= 2
		var res = _a - _x
		_a = res if res >= 0 else res + 256
	elif opcode == OP_ADD_X:
		_pc -= 2
		var res = _a + _x
		_a = res if res < 256 else res - 256
	elif opcode == OP_Z_JUMP:
		if _zf:
			_pc = param
	elif opcode == OP_JUMP:
		_pc = param

func reset():
	_pc = 0
	_x = 0
	_y = 0
	_a = 0
	_zf = false
