extends Control

var level = 1
var max_level = 1
var unlock_level = 1
var save_path = "user://data.cfg"
var part = ""
var teach = true
var target_part = null
# Called when the node enters the scene tree for the first time.
func save(_name, num):
	UpdateData.save(_name, num)
func load_game(_name, defaulte=null):
	return UpdateData.load_game(_name, defaulte)
func load_game2(_name, defaulte=null):
	var confige = ConfigFile.new()
	confige.load("user://files.cfg")
	return confige.get_value("user", _name, defaulte)
func _ready():
	Sound.connect_signals(self)
	for child in $polygons.get_children():
		var t = TriangleButton.new()
		var pos = child.global_position + child.offset
		if child.get_children().size() > 0:
			if child.get_meta("name", "") != "":
				child.get_child(0).text = child.get_meta("name")
			else:
				child.set_meta("name", child.get_child(0).text)
			child.add_to_group(child.get_meta("name"))
		for polygon in child.polygons:
			t.add_triangle(Triangle.new(child.polygon[polygon[0]] + pos, child.polygon[polygon[1]] + pos, child.polygon[polygon[2]] + pos))
		t.released.connect(_on_triangle_pressed.bind(child))
		t.hover.connect(_on_triangle_hover.bind(child))
		t.exit_point.connect(_on_triangle_exit_point.bind(child))
		add_child(t)
	$Camera2D.limit_bottom = $TextureRect.size.y
	$Camera2D.limit_right = $TextureRect.size.x
#	if FileAccess.file_exists(save_path):
#		level = load_game("level", 1)
#		teach = load_game("teach", true)
#		$VBoxContainer/HBoxContainer4/Control/Panel/Label.text = load_game('name', "")
#		$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = false
#		var part_list = [["levels_home", "h"], ["levels_village", "v"], ["levels_school", "s"], ["levels_mosque", "m"]]
#		for x in range(part_list.size()):
#			save("max_level_"+part_list[x][1], len(load_game2(part_list[x][0], [])))
#		part = load_game("part", 0)
#
#	match part:
#		0:
#			max_level = load_game("max_level_h", 1)
#			unlock_level = load_game("unlock_level_h", 1)
#		1:
#			max_level = load_game("max_level_v", 1)
#			unlock_level = load_game("unlock_level_v", 1)
#		2:
#			max_level = load_game("max_level_s", 1)
#			unlock_level = load_game("unlock_level_s", 1)
#		3:
#			max_level = load_game("max_level_m", 1)
#			unlock_level = load_game("unlock_level_m", 1)
#
#	if level > max_level:
#		level = max_level
#		save("level", level)
#
#	if load_game("img", "") != "":
#
#		$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/Label.hide()
#		var tex = load("res://sprite/user_img.png")
#		if FileAccess.file_exists("user://icons/" + load_game("img")):
#			var image = Image.load_from_file("user://icons/" + load_game("img"))
#			tex = ImageTexture.create_from_image(image)
#		else:
#			save("img", "")
#			$VBoxContainer/HBoxContainer4/Control/Panel/TextureButton2.hide()
#		$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture_normal = tex
#	else:
#		$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture_normal = load("res://sprite/user_img.png")
#	$VBoxContainer/HBoxContainer4/Control/Panel/Label2.text = "امتیاز : "+ str(load_game("score", 0))
#	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect2.value = load_game("score", 0) * 100 / 5000
#	$icons/icons.button_pressed.connect(_on_icons_button_pressed)
	ChangeScene.emitting(false)
	part = load_game("part_city", "")
	if part != "":
		if get_tree().has_group(part):
			$CanvasLayer.hide()
			$PopupPanel.hide()
			target_part = get_tree().get_first_node_in_group(part)
			$Camera2D.enabled = false
			save("part_city", target_part.get_meta("name"))
			get_tree().get_root().add_child(preload("res://scenes/levels.tscn").instantiate())
			for child in $polygons.get_children():
				child.z_index = 0
func _process(delta):
	pass
func _input(event):
	if event is InputEventScreenDrag:
		$Camera2D.position += -event.relative
	
	

	

func _on_label_text_submitted(new_text):
	var t = new_text.split(" ")
	var text = ""
	for x in t:
		if x != "":
			text += x
	if text != "" and new_text != "":
		save("name", new_text)
		$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = false


func _on_edit_name_pressed():
	$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = true


func _on_icons_button_pressed(img):
	save("img_mode", 0)
	save("img", img)
	save("rotate_img", 0)
	var image = Image.load_from_file("user://icons/" + load_game("img"))
	var tex = ImageTexture.create_from_image(image)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture_normal = tex
	$icons.hide()
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/Label.hide()


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and not get_tree().has_group("levels"):
		_on_persian_button_3_pressed()
func _on_levels_pressed():
	var m = preload("res://scenes/menu_levels.tscn").instantiate()
	m.teach = teach
	get_tree().get_root().add_child(m)


func _on_persian_button_pressed():
	Exit.change_scene("res://scenes/main.tscn")

func back_zoom():
	$Camera2D.position = get_viewport().size / 2
	$Camera2D.enabled = true
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D, "zoom", Vector2(1, 1), 1)
	tween.play()
func _on_persian_button_3_pressed():
	Exit.change_scene("res://scenes/start.tscn")
#
#func _on_gui_input(event):
#	if event is InputEventScreenTouch:
#		var t = $VBoxContainer/HBoxContainer4/Control/Panel/Label.text.split(" ")
#		var text = ""
#		for x in t:
#			if x != "":
#				text += x
#		if text != "" and $VBoxContainer/HBoxContainer4/Control/Panel/Label.text != "":
#			save("name", $VBoxContainer/HBoxContainer4/Control/Panel/Label.text)
#			$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = false


func _on_label_gui_input(event):
	if event.is_pressed():
		$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = true
func _on_triangle_pressed(btn):
	if part == "":
		if !get_tree().has_group("levels"):
			if target_part == null:
				target_part = btn
				
			elif target_part == btn:
				_on_button_pressed()
			else:
				target_part = btn


func _on_triangle_hover(btn):
	if part == "":
		if !get_tree().has_group("levels") and $Camera2D.zoom.x < 1.1:
			btn.scale = Vector2.ONE * 1.1
			btn.z_index = 1
		
func _on_triangle_exit_point(btn):
	btn.scale = Vector2.ONE
	btn.z_index = 0



func _on_button_pressed():
	if target_part:
		$CanvasLayer.hide()
		$PopupPanel.hide()
		$Camera2D.position = target_part.global_position
		var tween = get_tree().create_tween()
		tween.tween_property($Camera2D, "zoom", Vector2(4, 4), 1)
		tween.play()
		await tween.finished
		$Camera2D.enabled = false
		save("part_city", target_part.get_meta("name"))
		get_tree().get_root().add_child(preload("res://scenes/levels.tscn").instantiate())
		for child in $polygons.get_children():
			child.z_index = 0


func _on_h_scroll_bar_scrolling():
	$Camera2D.position.x = ($CanvasLayer/HScrollBar.value * 20)
