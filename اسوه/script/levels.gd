extends Control
enum Mode{Home, Village, school, mosque}
var mode = Mode.Home
var max_level = 1
var unlock_level = 1
var save_path = "user://data.cfg"
var col = 5
func save(_name, num):
	UpdateData.save(_name, num)
func load_game(_name, defaulte=null):
	return UpdateData.load_game(_name, defaulte)
func max_level2(ty) -> int:
	if DirAccess.dir_exists_absolute("res://files/"+ty):
		var dir = DirAccess.get_files_at("res://files/"+ty)
		return dir.size()
	else:
		DirAccess.make_dir_absolute("res://files/"+ty)
		return 1
func _ready():
	#Sound.connect_signals(self)
	mode = load_game("part", "")
	match mode:
		0:
			$biography.texture = preload("res://sprite/شهید+خرازی_.jpg")
		1:
			$biography.texture = preload("res://sprite/4980337.jpg")
		2:
			$biography.texture = preload("res://sprite/4024035.jpg")
		3:
			$biography.texture = preload("res://sprite/9.jpg")
		4:
			$biography.texture = preload("res://sprite/4992624.jpg")
		5:
			$biography.texture = preload("res://sprite/Layer 2.jpg")
	$biography.set_texture($biography.texture)
	var num = max_level2(["خرازی", "تورجی زاده", "کاظمی", "حجازی", "زاهدی", "نیلفروشان"][mode])
	unlock_level = load_game("unlock_level_"+str(mode), 1)
	add_levels(num)
	$AnimationPlayer.play("zoom")
	
func add_levels(max):
	for x in range(max):
		var btn = $Button.duplicate()
		var anime = $Button/AnimationPlayer.duplicate()
		if x < 10:
			btn.text = str(" ", x + 1)
		else:
			btn.text = str(x + 1)
		btn.pressed.connect(on_btn_pressed.bind(x + 1))
		btn.get_child(0).queue_free()
		$ScrollContainer/GridContainer.add_child(btn)
		if x + 1 == unlock_level:
			btn.add_child(anime)
			anime.root_node = btn.get_path()
			anime.play("last_level")
#			var pos = Vector2((x % $ScrollContainer/GridContainer.columns) * (btn.size.x + $ScrollContainer/GridContainer.get_theme_constant("h_separation")), (x / $ScrollContainer/GridContainer.columns) * (btn.size.y + $ScrollContainer/GridContainer.get_theme_constant("v_separation"))) + $ScrollContainer.position + Vector2(btn.size.x / 2, 0)
		else:
			btn.add_theme_stylebox_override("normal", preload("res://styles/levels_btn_normal.tres"))
			btn.add_theme_stylebox_override("pressed", preload("res://styles/levels_btn_p.tres"))
			btn.add_theme_stylebox_override("hover", preload("res://styles/levels_btn_h.tres"))
		
		if x + 1 == load_game("level", 1):
			var p = preload("res://scenes/pigeon.tscn").instantiate()
			p.start(UpdateData.random_pos(Rect2(-200, -200, get_viewport().size.x + 400, get_viewport().size.y + 400), Rect2(0, 0, get_viewport().size.x, get_viewport().size.y)),Vector2(btn.size.x / 2, 0))
			btn.add_child(p)
		
		
		if x + 1 > unlock_level:
			btn.disabled = true
		btn.show()
		
		
func write_num(_name, num):
	var file = FileAccess.open("user://files/"+_name+".txt", FileAccess.WRITE)
	file.store_var(num)
	file.close()

func reset_btn():
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("reset_btn")
	for lv in range(max_level):
		var btn = $Node2D/buttons.get_child(lv)
		btn.text = str(lv + 1)
		btn.pressed.connect(on_btn_pressed.bind(lv + 1))
		if lv + 1 > unlock_level:
			btn.disabled = true
		else :
			btn.disabled = false
		
func add_btn_mobile(max_lv):
	var texturs_normal = ["res://sprite/honey.png", "res://sprite/iconmahale-.png", "res://sprite/gol3.png", "res://sprite/3.png"]
	var texturs_disabled = ["res://sprite/empty_honey.png", "res://sprite/iconmahale1-.png", "res://sprite/gol4.png", "res://sprite/5.png"]
	var texturs_pressed = ["res://sprite/honey (11).png", "res://sprite/iconmahale13-.png", "res://sprite/gol5.png", "res://sprite/4.png"]
	for x in range(int(max_lv / col) + 1):
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		match mode:
			0:
				hbox.add_theme_constant_override("separation", 110)
				
			1:
				hbox.add_theme_constant_override("separation", 110)
				
			2:
				hbox.add_theme_constant_override("separation", 90)
				
			3:
				hbox.add_theme_constant_override("separation", 100)
	
		$ScrollContainer2/VBoxContainer.add_child(hbox)
	for lv in range(max_lv):
		var btn = TextureButton.new()
		btn.texture_normal = load(texturs_normal[mode])
		btn.texture_disabled = load(texturs_disabled[mode])
		btn.texture_pressed = load(texturs_pressed[mode])
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.ignore_texture_size = true
		btn.pressed.connect(on_btn_pressed.bind(lv + 1))
		btn.size = Vector2(100, 100)
		btn.add_theme_constant_override("outline_size", 10)
		var label = Label.new()
		label.add_theme_color_override("font_color", Color("1a6f4f"))
		label.add_theme_font_override("font", preload("res://fonts/B Titr Bold_0.ttf"))
		label.add_theme_color_override("font_outline_color", Color("fdfdfd"))
		label.text = str(lv + 1)
		match mode:
			0:
				label.add_theme_font_size_override("font_size", 45)
				label.add_theme_constant_override("outline", 5)
				btn.size = Vector2(100, 100)
			1:
				label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
				label.add_theme_font_size_override("font_size", 50)
				label.add_theme_constant_override("outline_size", 5)
				label.add_theme_color_override("font_outline_color", Color("ffffff"))
			2:
				btn.size = Vector2(80, 130)
				label.add_theme_constant_override("outline_size", 5)
				label.add_theme_color_override("font_outline_color", Color.BLACK)
				label.add_theme_color_override("font_color", Color.WHEAT)
				label.add_theme_font_size_override("font_size", 45)
				label.add_theme_constant_override("outline", 5)
			3:
				btn.size = Vector2(90, 90)
				label.add_theme_constant_override("outline_size", 5)
				label.add_theme_color_override("font_outline_color", Color.BLACK)
				label.add_theme_color_override("font_color", Color.RED)
				label.add_theme_font_size_override("font_size", 45)
				label.add_theme_constant_override("outline", 5)
		label.set_anchors_preset(Control.PRESET_FULL_RECT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		btn.add_child(label)
		if lv + 1 > unlock_level:
			btn.disabled = true
		var control = Control.new()
		control.add_child(btn)
		$ScrollContainer2/VBoxContainer.get_child(int(lv / col)).add_child(control)

func on_btn_pressed(lv):
	var d = load_game("level_data", [1, ""])
	var s = {}
	if d is String:
		var j = JSON.new()
		d = j.parse_string(d)
	if d[0] != lv or d[1] != mode:
		s["answer_data"] = []
	if d[0] == lv and d[1] == mode:
		if get_tree().has_group("main"):
			queue_free()
			return
	s["level"] = lv
	s["type"] = "کاوش در منطقه"
	UpdateData.multy_save(s)
	Exit.change_scene("res://scenes/main.tscn")


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_persian_button_pressed()

func _on_persian_button_pressed():

	if get_tree().has_group("main"):
		if get_tree().has_group("menu_levels"):
			get_tree().get_nodes_in_group("menu_levels")[0].queue_free()
		queue_free()
	else:
		
		Exit.change_scene("res://scenes/start.tscn")
	

func _on_animation_player_2_animation_finished(anim_name):
	$ScrollContainer2.size = $ScrollContainer.size
	$ScrollContainer2.position = $ScrollContainer.position


func _on_button_2_pressed() -> void:
	var g = preload("res://scenes/guess_name.tscn").instantiate()
	g.texture = $biography.duplicate()
	get_tree().get_root().add_child(g)
