extends Control
var target_word = []
var word
var text = ""
var true_answer = false
var answered = false
var drag = true
var level = 1
var unlock_level = 1
var type
var data = {}
var words = []
var vgrid = VGrid.new()
var max_size = 100
var rotate_words = false
var back_rotate_words = false
var stop_rotate_words = false
var speed_rotate = 0
var save_path = "user://data.cfg"
var w_answer_list = []
var table_box = []
var score = 0
var part = 0
var answer_data = []
var table_word_r = []
var table_word_c = []
var menu_open = false
var max_level = 1
var ques_menu = false
var quess = []
var answer_list = []
var word_list = []
var current_word = 0
var max_word = 1
func update_score(num=0):
	score += num
	save("score", score)
	$Control2/Label.text = str(score)
func find_word(box):
	next_words()
	box.get_child(0).emitting = true
	box.get_child(1).emitting = true
func help(state, _score, _id):
	randomize()
	var result = load_game("score", 0) >= _score
	if result:
		$Control2/Label.text = str(load_game("score", 0))
		if state == 0:
			var words2 = []
			if data.state == 0:
				for x in range(answer_list.size()):
					for y in range(answer_list[x].length()):
						words2.append(Vector2(x, y))
						for a in w_answer_list:
							if x == a.x and y == a.y:
								words2.erase(Vector2(x, y))
				if words2.size() > 0:
					var z = randi_range(0, words2.size() - 1)
					var x = words2[z].x
					var y = words2[z].y
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					hbox.get_child(y).text = answer_list[x][answer_list[x].length() - 1 - y]
					find_word(hbox.get_child(y))
					w_answer_list.append(Vector2(x, y))
					answer_data[x][y] = answer_list[x][answer_list[x].length() - 1 - y]
			if data.state == 1:
				for box in table_box:
					words2.append(box)
					if get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0].text != "":
						words2.erase(box)
				if words2.size() > 0:
					var z = randi_range(0, len(words2) - 1)
					var x = words2[z].x
					var y = words2[z].y
					var box = get_tree().get_nodes_in_group("answer_"+str(x)+"_"+str(y))[0]
					box.text = data.data[x][y]
					answer_data[x][y] = data.data[x][y]
					find_word(box)
			save("answer_data", answer_data)
			if words2.size() == 1:
				await get_tree().create_timer(1.5).timeout
				win()
		if state == 1:
			true_answer_animation()
			var words_list = []
			var words_r_list = []
			var words_c_list = []
			if data.state == 0:
				for x in range(answer_list.size()):
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					words_list.append(x)
					var a = true
					for box in hbox.get_children():
						if box.text == "":
							a = false
					if a:
						words_list.erase(x)
				if words_list.size() > 0:
					var z = randi_range(0, len(words_list) - 1)
					var x = words_list[z]
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					for y in range(hbox.get_children().size()):
						hbox.get_child(y).text = answer_list[x][answer_list[x].length() - 1 - y]
						answer_data[x][y] = answer_list[x][answer_list[x].length() - 1 - y]
						find_word(hbox.get_child(y))
						w_answer_list.append(Vector2(x, y))
			if data.state == 1:
				
				for x in range(answer_list[0].size()):
					var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
					var a = false
					words_r_list.append(x)
					for box in boxs:
						if box.text == "":
							a = true
					if !a:
						words_r_list.erase(x)
				for x in range(answer_list[1].size()):
					var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
					words_c_list.append(x)
					var a = false
					for box in boxs:
						if box.text == "":
							a = true
					if !a:
						words_c_list.erase(x)
				if words_c_list.size() > 0 and words_r_list.size() > 0:
					var r = randi_range(0, 1)
					if r == 0:
						var z = randi_range(0, len(words_r_list) - 1)
						var x = words_r_list[z]
						var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
						for y in range(boxs.size()):
							boxs[y].text = answer_list[0][answer_list[0].size() - x - 1][answer_list[0][answer_list[0].size() - x - 1].length() - y - 1]
							answer_data[table_word_r[x][y].x][table_word_r[x][y].y] = data.data[table_word_r[x][y].x][table_word_r[x][y].y]
							find_word(boxs[y])
							w_answer_list.append(Vector2(x, y))
					if r == 1:
						var z = randi_range(0, len(words_c_list) - 1)
						var x = words_c_list[z]
						var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
						for y in range(boxs.size()):
							boxs[y].text = answer_list[1][x][y]
							answer_data[table_word_c[x][y].x][table_word_c[x][y].y] = data.data[table_word_c[x][y].x][table_word_c[x][y].y]
							find_word(boxs[y])
							w_answer_list.append(Vector2(x, y))
				elif words_c_list.size() > 0 and words_r_list.size() == 0:
					var z = randi_range(0, len(words_c_list) - 1)
					var x = words_c_list[z]
					var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
					for y in range(boxs.size()):
						boxs[y].text = answer_list[1][x][y]
						find_word(boxs[y])
						answer_data[table_word_c[x][y].x][table_word_c[x][y].y] = data.data[table_word_c[x][y].x][table_word_c[x][y].y]
						w_answer_list.append(Vector2(x, y))
				elif words_r_list.size() > 0 and words_c_list.size() == 0:
					var z = randi_range(0, len(words_r_list) - 1)
					var x = words_r_list[z]
					var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
					for y in range(boxs.size()):
						boxs[y].text = answer_list[0][answer_list[0].size() - x - 1][answer_list[0][answer_list[0].size() - x - 1].length() - y - 1]
						answer_data[table_word_r[x][y].x][table_word_r[x][y].y] = data.data[table_word_r[x][y].x][table_word_r[x][y].y]
						find_word(boxs[y])
						w_answer_list.append(Vector2(x, y))
			save("answer_data", answer_data)
			if words_list.size() == 1:
				await get_tree().create_timer(1.5).timeout
				win()
			if (words_c_list.size() == 0 and words_r_list.size() == 1) or (words_c_list.size() == 1 and words_r_list.size() == 0):
				await get_tree().create_timer(1.5).timeout
				win()
		if state == 2:
			true_answer_animation()
			if data.state == 0:
				for x in range(answer_list.size()):
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					for y in range(hbox.get_children().size()):
						find_word(hbox.get_child(y))
						hbox.get_child(y).text = answer_list[x][answer_list[x].length() - 1 - y]
			if data.state == 1:
				for box in table_box:
					get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0].text = data.data[box.x][box.y]
					find_word(get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0])
			await get_tree().create_timer(2).timeout
			win()
		
	else:
		$AnimationPlayer.play("score")
	

func save(_name, num):
	UpdateData.save(_name, num)
func load_game(_name, defaulte = null):
	return UpdateData.load_game(_name, defaulte)

func _ready():
	Sound.connect_signals(self)
	
	set_process(false)
	var tex = load("res://sprite/user_img.png")
	var img :PackedByteArray = load_game("image", [])
	var image = Image.new()
	if image.load_png_from_buffer(img) == OK:
		%TextureRect.texture = ImageTexture.create_from_image(image)
	elif image.load_jpg_from_buffer(img) == OK:
		%TextureRect.texture = ImageTexture.create_from_image(image)
	elif image.load_svg_from_buffer(img) == OK:
		%TextureRect.texture = ImageTexture.create_from_image(image)
	elif image.load_ktx_from_buffer(img) == OK:
		%TextureRect.texture = ImageTexture.create_from_image(image)
	elif image.load_webp_from_buffer(img) == OK:
		%TextureRect.texture = ImageTexture.create_from_image(image)
	elif image.load_bmp_from_buffer(img) == OK:
		%TextureRect.texture = ImageTexture.create_from_image(image)

	score = load_game("score", 0)
	level = load_game("level", 1)
	update_score()
	$CanvasLayer/Panel/VBoxContainer/Control/Label.text = load_game("name", "")
	answer_data = load_game("answer_data", [])
	part = load_game("part", 0)
	save("level_data", [level, part])
	unlock_level = load_game("unlock_level_"+str(part), 1)
	data = UpdateData.load_level(part, level)
	
	$Control2/Label2.text = "مرحلـه " + str(level)
	$TextureRect3/Line2D.position = -$TextureRect3.global_position
	if data.state == 0:
		var ans = []
		for a in data.answers:
			ans.append(a[1])
			answer_list.append(a[1])
		var list = []
		for t in ans:
			list.append(t.length())
		var list2 = []
		var _size = list.size()
		for t in range(_size):
			list2.append(list.min())
			list.erase(list.min())
		var list3 = []
		var l_words = []
		for l in list2:
			for x in range(ans.size()):
				if ans[x].length() == l:
					
					list3.append(ans[x])
					ans.erase(ans[x])
					break
		for a in list3:
			for w in data.answers:
				if a == w[1]:
					quess.append(w[0])
					word_list.append(w[2])
		var list4 = []
		var r = list2.size()
		if list2.size() > 6:
			r = (list2.size() / 2) + (list2.size() % 2)
			
		for l in range(r):
			if list2.size() > l + r:
				list4.append(list2[l] + list2[l + r])
		if list2.size() > 5:
			max_size = 80
		elif  list2.size() > 6:
			max_size = ((8 - list4.max()) * 5) + 80
		answer_list = list3
		
		vgrid.add_theme_constant_override("separation", 30)
		vgrid.layout_direction = Control.LAYOUT_DIRECTION_RTL
		vgrid.rows = r
		for x in range(answer_list.size()):
			add_answer(answer_list[x].length(), x, vgrid)
		$VBoxContainer/ScrollContainer.add_child(vgrid)
	else:
		add_answer(1, 0)
	max_word = data.answers.size()
	change_word()
	
	
	#var quess = data.ques.split("؟")
	for x in range(quess.size()):
		$Node2D/Panel/PersianLabel.text += str("[color=green]",x+1,". ", "[/color]") + quess[x] + "[tornado radius=2 freq=10][color=red]؟[/color][/tornado]" + "\n"
	#if data.ques == "":
		#$Button.hide()
	await get_tree().create_timer(0.5).timeout
	if data.state == 0:
		if answer_data.size() == 0:
			for x in range(answer_list.size()):
				var l = []
				for y in range(answer_list[x].length()):
					l.append("")
				answer_data.append(l)
		else:
			for x in range(answer_data.size()):
				if get_tree().has_group("answer"+str(x)):
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					var a = true
					for z in answer_data[x]:
						if z == "":
							a = false
						
					for y in range(hbox.get_children().size()):
						if answer_data[x][y] != "":
							w_answer_list.append(Vector2(x, y))
							hbox.get_child(y).text = answer_data[x][y]
						if a:
							find_word(hbox.get_child(y))
	if data.state == 1:
		if answer_data.size() == 0:
			for x in range(data.data.size()):
				var l = []
				for y in range(data.data[x].size()):
					l.append("")
				answer_data.append(l)
		else:
			for box in table_box:
				if answer_data[box.x][box.y] != "":
					get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0].text = data.data[box.x][box.y]
					find_word(get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0])
	
	set_process(true)
func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and not get_tree().has_group("levels"):
		_on_button_5_pressed()
func change_word():
	for child in $TextureRect3/words.get_children():
		child.queue_free()
	
	var word = word_list[current_word].split(" ")
	for x in range(max_word):
		if x == current_word:
			for box in get_tree().get_nodes_in_group("word_"+str(x)):
				if box is Label:
					box.play("light")
		else:
			for box in get_tree().get_nodes_in_group("word_"+str(x)):
				if box is Label:
					box.play("RESET")
	
	for x in range(word.size()):
		add_words(word[x], (360 / word.size()) * x)
	words = word
	if words.size() < 20:
		$TextureRect3/Line2D.width = 30 - words.size()
	else:
		$TextureRect3/Line2D.width = 2
func add_words(_name, degross):
	var label = preload("res://scenes/Label.tscn").instantiate()
	var node = Node2D.new()
	label.size2 = 80 -  (words.size() * 2)
	label.size = Vector2(.7 * label.size2, label.size2 + 1)
	label.text = "[rotate offset=20,20 range=0.1 freq="+str(1.5 * [1, -1][randi_range(0, 1)])+"]"+_name
	label.mouse_hover.connect(_on_Label_mouse_hover)
	label.mouse_exit.connect(_on_Label_mouse_exit)
	label.position = -label.size / 2
	node.add_child(label)
	var pivot = Vector2(0, .64).rotated(deg_to_rad(degross))
	var size2 = ($TextureRect3.size / 2)
	node.position = -(pivot * size2)
	$TextureRect3/words.add_child(node)
	
func add_answer(num, count, parent=$VBoxContainer/ScrollContainer/GridBoxContainer):
	var l = []
	var q = []
	if data.state == 0:
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.layout_direction = Control.LAYOUT_DIRECTION_LTR
		for x in range(num):
			var box = preload("res://scenes/box_word.tscn").instantiate()
			box.add_to_group("word_"+str(count))
			box.custom_minimum_size = Vector2.ONE * max_size
			box.label_settings.font_size = 60 * (max_size / 100.0)
			box.get_child(0).position = Vector2(max_size / 2, max_size)
			box.get_child(1).position = Vector2(max_size / 2, max_size / 2)
			hbox.add_child(box)
		hbox.add_theme_constant_override("separation", -max_size / 10.0)
		hbox.add_to_group("answer"+str(count))
		parent.add_child(hbox)
		
		
	else:
		
		$VBoxContainer/ScrollContainer/GridBoxContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer/GridBoxContainer.columns = data.data.size()
		max_size = ((8 - data.data.size()) * 5) + 80
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("v_separation" , -max_size / 10.0)
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("h_separation" , -max_size / 10.0)
		
		for x in range(data.data.size()):
			for y in range(data.data[x].size()):
				var control = Control.new()
				control.mouse_filter = Control.MOUSE_FILTER_IGNORE
				var box = preload("res://scenes/box_word.tscn").instantiate()
				box.custom_minimum_size = Vector2.ONE * max_size
				box.label_settings.font_size = 60 * (max_size / 100.0)
				box.get_child(0).position = Vector2(max_size / 2, max_size)
				box.get_child(1).position = Vector2(max_size / 2, max_size / 2)
				control.custom_minimum_size = box.custom_minimum_size
				for c in range(answer_list[2].size()):
					if x == 0 and y == 0 and "_00_" in answer_list[2][c]:
						box.add_to_group("answer_c_"+str(c))
						l.append([Vector2(x, y), c])
					elif ("_" + str(y + (x * data.data[x].size())) + "_") in answer_list[2][c]:
						l.append([Vector2(x, y), c])
						box.add_to_group("answer_c_"+str(c))

				for r in range(answer_list[3].size()):
					
					if x == 0 and y == 0 and "_00_" in answer_list[3][r]:
						box.add_to_group("answer_r_"+str(r))
						q.append([Vector2(x, y), r])
					elif ("_" + str(y + (x * data.data[x].size())) + "_") in answer_list[3][r]:
						box.add_to_group("answer_r_"+str(r))
						q.append([Vector2(x, y), r])
				if data.data[x][y] != " ":
					table_box.append(Vector2(x, y))
					box.add_to_group("answer_"+str(x)+"_"+str(y))
					$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(box)
				else:
					$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(control)
		for y in range(answer_list[3].size()):
			var z = []
			for x in range(q.size()):
				if q[x][1] == y:
					z.append(q[x][0])
			table_word_r.append(z)
		for y in range(answer_list[2].size()):
			var z = []
			for x in range(l.size()):
				if l[x][1] == y:
					z.append(l[x][0])
			table_word_c.append(z)
func win():
	if !$Panel.visible:
		var d = {}
		if level + 1 > unlock_level and level <= max_level:
			d["unlock_level_"+str(part)] = level + 1
			var lvl = load_game("lvl", 0)
			lvl += data.score
			d["lvl"] = lvl
			update_score(data.score)
			var data_pic = load_game("data_"+str(part), [])
			if data_pic is String:
				data_pic = UpdateData.get_json(data_pic)
			var pos = []
			var n = 0
			for x in range(data_pic.size()):
				n = data_pic.size() * data_pic[x].size()
				for y in range(data_pic[x].size()):
					if data_pic[x][y] == 0:
						pos.append(Vector2(x, y))
		
			for x in range((n / max_level)):
				if pos.size() > 0:
					var p = randi_range(0, len(pos) - 1)
					data_pic[pos[p].x][pos[p].y] = 1
					pos.remove_at(p)
			d["data_"+part] = data_pic
		d["answer_data"] = []
		if level < max_level:
			d["level"] = level + 1
		UpdateData.multy_save(d)
		$Panel.show()
		$Panel/AnimationPlayer.play("show")
func change_words_pos():
	var list = []
	var words2 = word_list[current_word].split(" ")
	randomize()
	for y in range(words2.size()):
		var x = randi_range(0, words2.size() - 1)
		list.append(words2[x])
		words2.remove_at(x)
	data.words = list
	for child in $TextureRect3/words.get_children():
		child.queue_free()
	for x in range(data.words.size()):
		add_words(data.words[x], (360 / data.words.size()) * x)
func set_modulate_children(color, obj):
	for child in obj.get_children():
		child.modulate = color
func _process(delta):
	
	if rotate_words:
		speed_rotate += 10 * delta
		$TextureRect3/words.rotate(deg_to_rad(speed_rotate))
		$TextureButton.rotation = $TextureRect3/words.rotation
		if speed_rotate >= 10:
			back_rotate_words = true
			rotate_words = false
			change_words_pos()
	if back_rotate_words:
		speed_rotate -= 10 * delta
		$TextureRect3/words.rotate(deg_to_rad(speed_rotate))
		$TextureButton.rotation = $TextureRect3/words.rotation
		if speed_rotate <= 1:
			speed_rotate = 0
			if $TextureRect3/words.rotation != 0:
				stop_rotate_words = true
			back_rotate_words = false
	if stop_rotate_words:
		if int(rad_to_deg($TextureRect3/words.rotation)) % 360 != 0:
			if int(rad_to_deg($TextureRect3/words.rotation)) % 360 != 180:
				$TextureRect3/words.rotate(deg_to_rad(-(180 - (int(rad_to_deg($TextureRect3/words.rotation)) % 360)) / abs(180 - (int(rad_to_deg($TextureRect3/words.rotation)) % 360))))
			else:
				$TextureRect3/words.rotate(deg_to_rad(1))
			$TextureButton.rotation = $TextureRect3/words.rotation
		else:
			$TextureRect3/words.rotation = 0
			$TextureButton.rotation = $TextureRect3/words.rotation
			stop_rotate_words = false
			drag = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if drag:
			set_modulate_children(Color.WHITE, $label_pos/Label)
			true_answer = false
			answered = false
			if word:
				if !target_word.has(word):
					target_word.append(word)
			$TextureRect3/Line2D.points = []
			for words2 in target_word:
				if words2:
					$TextureRect3/Line2D.add_point(words2.global_position + words2.size / 2)
			$TextureRect3/Line2D.add_point(get_global_mouse_position())
			if $TextureRect3/Line2D.points.size() > 0:
				$TextureRect3/Line2D.set_point_position(len($TextureRect3/Line2D.points) - 1, get_global_mouse_position())
			text = ""
			for words2 in target_word:
				var l = words2.text.split("]")
				text += l[l.size() - 1]
			$label_pos/Label.text = text
	else:
		for w in get_tree().get_nodes_in_group("word"):
			w.scale = Vector2.ONE
			w.add_theme_color_override("default_color", Color("da1b00"))
		var next_level = true
		if data.state == 0:
			for x in range(answer_list.size()):
				var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
				if text == answer_list[x]:
					for y in range(hbox.get_children().size()):
						if hbox.get_child(y).text == "":
							true_answer = true
							hbox.get_child(y).text = answer_list[x][answer_list[x].length() - 1 - y]
							w_answer_list.append(Vector2(x, y))
							answer_data[x][y] = answer_list[x][answer_list[x].length() - 1 - y]
							save("answer_data", answer_data)
							find_word(hbox.get_child(y))
						else:
							answered = true
				for y in range(hbox.get_children().size()):
					if hbox.get_child(y).text == "":
						next_level = false
		if data.state == 1:
			for x in range(answer_list[0].size()):
				var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
				if text == answer_list[0][answer_list[0].size() - x - 1]:
					for y in range(boxs.size()):
						if boxs[y].text == "":
							true_answer = true
							boxs[y].text = answer_list[0][answer_list[0].size() - x - 1][answer_list[0][answer_list[0].size() - x - 1].length() - y - 1]
							answer_data[table_word_r[x][y].x][table_word_r[x][y].y] = data.data[table_word_r[x][y].x][table_word_r[x][y].y]
							find_word(boxs[y])
							save("answer_data", answer_data)
							w_answer_list.append(Vector2(x, y))
						else:
							answered = true
				for y in range(boxs.size()):
					if boxs[y].text == "":
						next_level = false
			for x in range(answer_list[1].size()):
				var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
				if text == answer_list[1][x]:
					for y in range(boxs.size()):
						if boxs[y].text == "":
							true_answer = true
							
							boxs[y].text = answer_list[1][x][y]
							answer_data[table_word_c[x][y].x][table_word_c[x][y].y] = data.data[table_word_c[x][y].x][table_word_c[x][y].y]
							save("answer_data", answer_data)
							find_word(boxs[y])
							w_answer_list.append(Vector2(x, y))
						else:
							answered = true
				for y in range(boxs.size()):
					if boxs[y].text == "":
						next_level = false
		if text != "":
			drag = false
			if true_answer:
				$Timer.start()
				set_modulate_children(Color.GREEN, $label_pos/Label)
			elif answered:
				
				set_modulate_children(Color.YELLOW, $label_pos/Label)
			else:
				set_modulate_children(Color.RED, $label_pos/Label)
			target_word = []
			$TextureRect3/Line2D.points = []
			drag = true
			
			if next_level:
				await get_tree().create_timer(1).timeout
				win()
				
	$label_pos.global_position.x = ($TextureRect3.global_position.x + $TextureRect3.size.x / 2) - $label_pos/Label.size.x / 2



func _on_Label_mouse_exit(object):
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target_word.erase(object)
	word = null

func _on_Label_mouse_hover(object):
	if !target_word.has(object) and drag:
		target_word.append(object)
		object.scale = Vector2.ONE * 1.1
		object.add_theme_color_override("default_color", Color("000092"))

func _on_PersianButton_pressed():
	var m = preload("res://scenes/levels.tscn").instantiate()
	get_tree().get_root().add_child(m)
	menu_open = false
	$CanvasLayer/Panel/AnimationPlayer.play("close")

func _on_PersianButton2_pressed():
	menu_open = true
	$CanvasLayer/Panel/AnimationPlayer.play("open")


func _on_TextureButton_pressed():
	if !rotate_words and !stop_rotate_words and !back_rotate_words:
		rotate_words = true
		drag = false


func _on_button_5_pressed():
	Exit.change_scene("res://scenes/start.tscn")


func true_answer_animation():
	await get_tree().create_timer(0.5).timeout
	true_answer = false
	if !drag:
		text = ""
		$label_pos/Label.text = ""
func _on_help_button_pressed(state, _id):
	var _score = 500
	var p = load_game("purchases", {})
	if p.has(_id):
		_score = p[_id]
	help(state, _score, _id)
	menu_open = false
	$CanvasLayer/Panel/AnimationPlayer.play_backwards("open")


func _on_texture_button_pressed():
	menu_open = false
	$CanvasLayer/Panel/AnimationPlayer.play_backwards("open")



func _on_button_pressed():
	if !ques_menu and !$AnimationPlayer2.is_playing():
		$AnimationPlayer2.play("question")
		ques_menu = true
	else:
		$AnimationPlayer2.play_backwards("question")
		ques_menu = false
func _on_button_2_pressed():
	$AnimationPlayer2.play_backwards("question")
	ques_menu = false

func _gui_input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if menu_open and !$CanvasLayer/Panel/AnimationPlayer.is_playing():
				menu_open = false
				$CanvasLayer/Panel/AnimationPlayer.play_backwards("open")
			if ques_menu and event.is_pressed():
				$AnimationPlayer2.play_backwards("question")
				ques_menu = false
	if !menu_open:
		if event is InputEventScreenDrag:
			if event.position.x < 200 and event.relative.x > 10 and target_word.size() == 0:
				menu_open = true
				$CanvasLayer/Panel/AnimationPlayer.play("open")
	
	if event is InputEventScreenDrag:
		
		if event.relative.x < -30 and event.position.y > 1200 and event.position.y < 1800 and event.position.x > 371 and event.position.x < 867 and current_word < max_word - 1 and !$AnimationPlayer3.is_playing() and target_word.size() == 0:
			$AnimationPlayer3.play("change_word")
			current_word += 1
			change_word()
			
		if event.relative.x > 30 and event.position.y > 1200 and event.position.y < 1800 and event.position.x > 170 and event.position.x < 600 and current_word > 0 and !$AnimationPlayer3.is_playing() and target_word.size() == 0:
			$AnimationPlayer3.play("change_word_2")
			current_word -= 1
			change_word()
func next_words():
	for x in range(answer_data.size()):
		if get_tree().has_group("answer"+str(x)):
			for z in answer_data[x]:
				if z == "" and current_word != x:
					current_word = x
					$AnimationPlayer3.play("change_word")
					change_word()
func _on_timer_timeout():
	$bee/AnimatedSprite2D.play("default")
	


func _on_continue_button_pressed():
	if type == "کاوش در منطقه":
		Exit.change_scene("res://scenes/normal_menu.tscn")
	else:
		Exit.change_scene("res://scenes/time_travel_parts.tscn")
