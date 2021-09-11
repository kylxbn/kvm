extends Panel

var _cpu: K1
var _gpu: X1
var _ram: GenericRAM
var _mmc: MemoryMapper

var _display: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	_display = $Window/Panel/Screen
	
	_gpu = X1.new()
	_ram = GenericRAM.new()
	load_program()
	_mmc = MemoryMapper.new()
	
	_mmc.add_device(_ram, 0x00, 0xE0)
	_mmc.add_device(RandGen.new(), 0xE9, 0xE9)
	_mmc.add_device(_gpu, 0xF0, 0xFF)

	_cpu = K1.new(_mmc)
	
	$Window/MenuContainer/FileMenu.get_popup().connect("id_pressed", self, "_handle_file_menu")
	$Window/MenuContainer/SystemMenu.get_popup().connect("id_pressed", self, "_handle_system_menu")


func _handle_file_menu(id):
	match id:
		0:
			print("open")
		2:
			print('lol')
			get_tree().quit()

func _handle_system_menu(id):
	match id:
		0:
			$CPUClock.start()
		1:
			$CPUClock.stop()
	
func _process(_delta):
	if _gpu.changed:
		var image_texture = ImageTexture.new()
		image_texture.create_from_image(_gpu.get_image())
		_display.texture = image_texture
	
func _on_CPUClock_timeout():
	# var s = OS.get_ticks_usec()
	
	var count = 0
	while count < 30:
		_cpu.step()
		count += 1

	# print((OS.get_ticks_usec() - s) - 16666) 

func load_program():
	var code = [
		0xA0, 0xE9, # load $E9 (rand) to A
		0xA1, 0xD0, # save A to $D0
		0xA0, 0xD0, # load $D0 to A
		0xA2, 0xE9, # load $E9 (rand) to X
		0xB3,       # subtract X from A
		0x91, 0x04, # if ZFlag is set, jump to #$04
		# but it isn't equal, so
		0xA3, 0xD2, # save X to $D2
		# and we continue the loading of coordinates
		0xA0, 0xE9, # load $E9 (rand) to A
		0xA1, 0xD1, # save A to $D1
		0xA0, 0xD1, # load $D1 to A
		0xA2, 0xE9, # load $E9 (rand) to X
		0xB3,       # subtract X from A
		0x91, 0x11,  # if ZFlag is set, jump to #$11
		# but it isn't equal, so
		0xA3, 0xD3,  # save X to $D3
		# now we have the coordinates, let's
		# send them to the GPU
		0xA0, 0xD0, # load $D0 to A
		0xA1, 0xF0, # save A to $F1 (X1)
		0xA0, 0xD1, # load $D1 to A
		0xA1, 0xF1, # save A to $F2 (Y1)
		0xA0, 0xD2, # load $D2 to A
		0xA1, 0xF2, # save A to $F3 (X2)
		0xA0, 0xD3, # load $D3 to A
		0xA1, 0xF3, # save A to $F4 (Y1)
		# now let's set the color
		0xA0, 0xE9, # load $E9 (rand) to A
		0xA1, 0xF4, # save A to $F4 (red)
		0xA0, 0xE9, # load $E9 (rand) to A
		0xA1, 0xF5, # save A to $F5 (green)
		0xA0, 0xE9, # load $E9 (rand) to A
		0xA1, 0xF6, # save A to $F6 (blue)
		# now let's draw!
		0xA1, 0xFF, # save A to $F0 (trigger draw_line)
		0x90, 0x00, # jump to $00 
	]
	for index in range(code.size()):
		_ram.set_at(index, code[index])
