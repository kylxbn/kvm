extends Panel

var _cpu: K1
var _gpu: X1
var _ram: GenericRAM
var _mmc: MemoryMapper
var _hdd: GenericHDD

var _display: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title('KVM v0.0.1')
	randomize()
	
	_display = $Window/Panel/Screen
	
	_gpu = X1.new()
	_ram = GenericRAM.new(0x1000)
	_mmc = MemoryMapper.new()	
	_hdd = GenericHDD.new()
	
	_mmc.add_device(_ram, 0x0000, 0x0FFF)
	_mmc.add_device(RandGen.new(), 0xF0E9, 0xF0E9)
	_mmc.add_device(_gpu, 0xF0F0, 0xF0FF)
	_mmc.add_device(_hdd, 0xF100, 0xF302)

	_cpu = K1.new(_mmc)
	
	$Window/MenuContainer/FileMenu.get_popup().connect("id_pressed", self, "_handle_file_menu")
	$Window/MenuContainer/SystemMenu.get_popup().connect("id_pressed", self, "_handle_system_menu")

	$Window/StatusContainer/Status.text = 'Ready.'

func _handle_file_menu(id):
	match id:
		0:
			$DiskFileDialog.popup()
		1:
			$BootFileDialog.popup()
		3:
			get_tree().quit()

func _handle_system_menu(id):
	match id:
		0:
			$CPUClock.start()
			$Window/StatusContainer/Status.text = 'System running.'
		1:
			$CPUClock.stop()
			$Window/StatusContainer/Status.text = 'System stopped.'
		3:
			$CPUClock.stop()
			_ram.reset()
			_gpu.reset()
			_cpu.reset()
			$Window/StatusContainer/Status.text = 'System reset.'
	
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

func _on_DiskFileDialog_file_selected(path):
	var file = File.new()
	file.open(path, File.READ_WRITE)
	_hdd.set_file(file)	
	$Window/StatusContainer/Status.text = 'Attached file ' + path + ' to HDD controller'


func _on_BootFileDialog_file_selected(path):
	var file = File.new()
	file.open(path, File.READ)
	var bytes = file.get_len()
	bytes = bytes if bytes < 256 else 256
	for index in bytes:
		_ram.set_at(index, file.get_8())
	file.close()
	$Window/StatusContainer/Status.text = 'Loaded file ' + path + ' to bootloader space'
