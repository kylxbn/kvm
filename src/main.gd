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
	_ram = GenericRAM.new(0x1000)
	load_program()
	_mmc = MemoryMapper.new()
	
	_mmc.add_device(_ram, 0x0000, 0x0FFF)
	_mmc.add_device(RandGen.new(), 0xF0E9, 0xF0E9)
	_mmc.add_device(_gpu, 0xF0F0, 0xF0FF)

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
		0xA0, 0xE9, 0xF0, # load $F0E9 (rand) to A
		0xA1, 0xD0, 0x00, # save A to $00D0
		0xA0, 0xD0, 0x00, # load $00D0 to A
		0xA2, 0xE9, 0xF0, # load $E9 (rand) to X
		0xB3,             # subtract X from A
		0x91, 0x06, 0x00, # if ZFlag is set, jump to #$0006
		# but it isn't equal, so
		0xA3, 0xD2, 0x00, # save X to $00D2
		# and we continue the loading of coordinates
		0xA0, 0xE9, 0xF0, # load $F0E9 (rand) to A
		0xA1, 0xD1, 0x00, # save A to $00D1
		0xA0, 0xD1, 0x00, # load $00D1 to A
		0xA2, 0xE9, 0xF0, # load $0FE9 (rand) to X
		0xB3,       # subtract X from A
		0x91, 0x19, 0x00, # if ZFlag is set, jump to #$0019
		# but it isn't equal, so
		0xA3, 0xD3, 0x00, # save X to $00D3
		# now we have the coordinates, let's
		# send them to the GPU
		0xA0, 0xD0, 0x00, # load $00D0 to A
		0xA1, 0xF0, 0xF0, # save A to $F0F1 (X1)
		0xA0, 0xD1, 0x00, # load $00D1 to A
		0xA1, 0xF1, 0xF0, # save A to $F0F2 (Y1)
		0xA0, 0xD2, 0x00, # load $00D2 to A
		0xA1, 0xF2, 0xF0, # save A to $F0F3 (X2)
		0xA0, 0xD3, 0x00, # load $00D3 to A
		0xA1, 0xF3, 0xF0, # save A to $F0F4 (Y1)
		# now let's set the color
		0xA0, 0xE9, 0xF0, # load $F0E9 (rand) to A
		0xA1, 0xF4, 0xF0, # save A to $F0F4 (red)
		0xA0, 0xE9, 0xF0, # load $F0E9 (rand) to A
		0xA1, 0xF5, 0xF0, # save A to $F0F5 (green)
		0xA0, 0xE9, 0xF0, # load $F0E9 (rand) to A
		0xA1, 0xF6, 0xF0, # save A to $F0F6 (blue)
		# now let's draw!
		0xA1, 0xFF, 0xF0, # save A to $F0FF (trigger draw_line)
		0x90, 0x00, 0x00, # jump to $0000 
	]
	for index in range(code.size()):
		_ram.set_at(index, code[index])
