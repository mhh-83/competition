extends Control

var words = []
var data = {}
var level = 1
var levels = []
var ques = ""
var key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ4Y2hvcm9uZm1tdmNpZGN6eHJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY0Mzk1MTksImV4cCI6MjAzMjAxNTUxOX0.z2mQsuIfV48YRW4RWi4ueT_RWED4IeHhrn9xR0tar9o"
var text_list = []
var choice_list = []
var match_list = []
var last_data = []
var part = 0
var url = "https://misaghgame.ir"
var group = 1
var type = 0
var parts = [["آران و بیدگل", "اردستان", "اصفهان", "برخوار", "بوئین میاندشت", "تیران و کرون",
 "چادگان", "خمینی‌شهر", "خوانسار", "خور و بیابانک", "دهاقان", "سمیرم", "شاهین‌شهر و میمه",
 "شهرضا", "فریدن", "فریدون‌شهر", "فلاورجان", "کاشان", "گلپایگان", "لنجان",
 "مبارکه", "نائین", "نجف‌آباد", "نطنز"],
["انقلاب", "دفاع حرم", "سلامت", "امنیت", "ترور"]]
var http_poll = HTTPRequest.new()
var http_push = HTTPRequest.new()


#Nodes
@onready var spin_box = %SpinBox
@onready var option_button = %OptionButton
@onready var option_button_2 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer9/OptionButton2"
@onready var spin_box_3 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer8/SpinBox3"
@onready var line_edit = $"مراحل/HBoxContainer/VBoxContainer2/LineEdit"
@onready var spin_box_4 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer5/SpinBox4"
@onready var spin_box_5 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer6/SpinBox5"
@onready var line_edit_2 = $"مراحل/HBoxContainer/VBoxContainer2/LineEdit2"
@onready var spin_box_6 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer10/SpinBox"
@onready var spin_box_7 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer12/SpinBox"
@onready var texture_rect = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer7/Control/TextureRect"
@onready var words_node = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer7/Control/TextureRect/words"
@onready var h_box_container_3 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer3"
@onready var h_box_container_7 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer7"
@onready var h_box_container_6 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer6"
@onready var h_box_container_5 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer5"
@onready var h_box_container_10 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer10"
@onready var h_box_container_12 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer12"
@onready var label_3 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer9/Label3"
@onready var label_2 = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer9/Label2"


func update_data():
	show_alert("بارگذاری انجام شد", 1)
	var j= JSON.new()
	if data.has("answers") and data.answers != null:
		data.answers = data.answers
	
	if data.has("score"):
		spin_box_3.value = data.score
	if data.state <= 1:
		option_button.select(data.state)
		
		spin_box_4.value = data.answers.size()
		print(data.answers)
		if option_button.selected == 1:
			spin_box_5.value = data.data.size()
		
		
		if get_tree().has_group("answer"):
			print(get_tree().get_nodes_in_group("answer"))
			for x in range(get_tree().get_nodes_in_group("answer").size()):
				get_tree().get_nodes_in_group("answer")[x].get_node("HBoxContainer2/LineEdit").text = data.answers[x][2]
				get_tree().get_nodes_in_group("answer")[x].get_node("HBoxContainer/answer").text = data.answers[x][1]
				get_tree().get_nodes_in_group("answer")[x].get_node("LineEdit").text = data.answers[x][0]
		if get_tree().has_group("table"):
			data.data = data.data
			get_tree().get_nodes_in_group("table")[0].update_data(data.data)
			get_tree().get_nodes_in_group("table")[0].words = words
		
	
func max_level(ty) -> int:
	if DirAccess.dir_exists_absolute("res://files/"+%type.get_item_text(ty)):
		var dir = DirAccess.get_files_at("res://files/"+%type.get_item_text(ty))
		return dir.size() + 1
	else:
		DirAccess.make_dir_absolute("res://files/"+%type.get_item_text(ty))
		return 1
func add_words(_name, degross):
	var label = preload("res://scenes/Label.tscn").instantiate()
	var node = Node2D.new()
	if words.size() * 3 < 100:
		label.size2 = 100 -  (words.size() * 3)
	else:
		label.size2 = 2
	
	label.text = _name
	
	label.position = -label.size / 2
	node.add_child(label)
	var pivot = Vector2(0, .7).rotated(deg_to_rad(degross))
	var size2 = (texture_rect.size / 2)
	node.position = -(pivot * size2)
	words_node.position = (texture_rect.size / 2) - Vector2(20, 10)
	words_node.add_child(node)
func answer_box(index):
	text_list = []
	choice_list = []
	match_list = []
	last_data = []
	if get_tree().has_group("answer"):
		for answer in get_tree().get_nodes_in_group("answer"):
			answer.remove_from_group("answer")
			text_list.append([answer.get_node("LineEdit").text, answer.get_node("HBoxContainer/answer").text, answer.get_node("HBoxContainer2/LineEdit").text])
	
	if get_tree().has_group("table"):
		last_data = get_tree().get_nodes_in_group("table")[0].data
	for child in h_box_container_3.get_children():
		h_box_container_3.remove_child(child)
	for child in %GridContainer.get_children():
		child.queue_free()
		
	match index:
		0:
			for x in range(spin_box_4.value):
				var option = $VBoxContainer.duplicate()
				option.show()
				option.add_to_group("answer")
				option.get_node("HBoxContainer/answer").text_changed.connect(answer_box_text_changed.bind(option.get_node("HBoxContainer/answer")))
				if x <= text_list.size() - 1:
					option.get_node("HBoxContainer2/LineEdit").text = text_list[x][2]
					option.get_node("LineEdit").text = text_list[x][0]
					option.get_node("HBoxContainer/answer").text = text_list[x][1]
				$"مراحل/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer".add_child(option)
			
		
		1:
			var table = preload("res://scenes/table.tscn").instantiate()
			table.words = words
			table.col = spin_box_5.value
			table._reload(last_data)
			h_box_container_3.add_child(table)
		

func _on_OptionButton_item_selected(index, change_level=true):
	data.state = index
	print(index)
	%HBoxContainer2.show()
	%HBoxContainer3.hide()
	%ScrollContainer.hide()
	match index:
		0:
			%ScrollContainer.show()
			h_box_container_6.hide()
			h_box_container_5.show()
			h_box_container_10.hide()
		1:
			%HBoxContainer3.show()
			h_box_container_5.hide()
			h_box_container_6.show()
			h_box_container_10.hide()
			
	if change_level:
		answer_box(option_button.selected)
func _on_SpinBox_changed(value):
	answer_box(option_button.selected)
	spin_box_6.max_value = value

func comb(n:int):
	var k = 1
	for x in range(n):
		k *= (n - x)
	return k
func show_alert(_text, state):
	if state == 0:
		var anime = $AnimationPlayer.get_animation("erore")
		anime.track_insert_key(2, 3, _text)
		$AnimationPlayer.play("erore", 0, 2)
	if state == 1:
		var anime = $AnimationPlayer.get_animation("successfully")
		anime.track_insert_key(2, 3, _text)
		$AnimationPlayer.play("successfully", 0, 2)
func _on_button_pressed():
	var list = []
	var empty_box = false
	data.score = $"مراحل/HBoxContainer/VBoxContainer/HBoxContainer8/SpinBox3".value
	data.state = %OptionButton.selected
	if get_tree().has_group("answer"):
		var answers = []
		for option in get_tree().get_nodes_in_group("answer"):
			var answer = option.get_node("HBoxContainer/answer")
			var ques2 = option.get_node("LineEdit")
			var words2 = option.get_node("HBoxContainer2/LineEdit")
			if answer.text != "" and answer.text.split(" ").size() == 1:
				answers.append([ques2.text, answer.text, words2.text])
		data.answers = answers
		
	elif get_tree().has_group("table"):
		var table = get_tree().get_nodes_in_group("table")[0]
		data.answers = table.answers()
		data.data = table.data
		var boxs = []
		if get_tree().has_group("box"):
			boxs = get_tree().get_nodes_in_group("box")
		if boxs.size() == 0:
			empty_box = true
		for x in range(boxs.size()):
			if boxs[x].text == "" or boxs[x].text == " ":
				boxs[x].add_theme_stylebox_override("normal", preload("res://styles/LineEdit2_e.tres"))
				empty_box = true
	save_level(type, level, data)
func _on_button_2_pressed():
	spin_box_3.value = 1
	%time.value = 1
	for answer in get_tree().get_nodes_in_group("answer"):
		answer.get_node("HBoxContainer2/LineEdit").text = ""
		answer.get_node("HBoxContainer/answer").text = ""
		answer.get_node("LineEdit").text = ""

	if get_tree().has_group("table"):
		get_tree().get_nodes_in_group("table")[0]._reload()
	answer_box(option_button.selected)
	
	


func _on_button_3_pressed():
	data = load_level(%type.selected, level)
	update_data()
func save_level(ty, lv, _data):
	if !DirAccess.dir_exists_absolute("res://files/"+%type.get_item_text(ty)):
		DirAccess.make_dir_absolute("res://files/"+%type.get_item_text(ty))
	var file = FileAccess.open("res://files/"+%type.get_item_text(ty)+"/level_"+str(lv)+".json", FileAccess.WRITE)
	file.store_line(JSON.stringify(_data))
	file.close()

func load_level(ty, lv, _data={}):
	var file = FileAccess.open("res://files/"+%type.get_item_text(ty)+"/level_"+str(lv)+".json", FileAccess.READ)
	var d = file.get_as_text()
	if d:
		_data = JSON.parse_string(d)
	return _data
func _on_question_text_changed():
	ques = line_edit.text


func _on_button_4_pressed():
	get_tree().quit()


func _on_line_edit_text_changed(new_text):
	
	var list = new_text.split(" ")
	for child in words_node.get_children():
		words_node.remove_child(child)
	words = []
	for t in list:
		if t != "" and t != " ":
			words.append(t)
	for x in range(words.size()):
		add_words(words[x], (360 / words.size()) * x)
	data.words = words
	if get_tree().has_group("table"):
		get_tree().get_nodes_in_group("table")[0].words = words


func answer_box_text_changed(t, answer):
	if get_tree().has_group("choice"):
		answer.modulate = Color.WHITE
	elif get_tree().has_group("test"):
		answer.add_theme_stylebox_override("normal", preload("res://styles/test_btn_n.tres"))
	else:
		answer.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_n.tres"))
	

func _on_spin_box_value_changed(value):
	data.level = value
	level = value


func _on_Score_changed(value):
	data.score = value


func _on_part_item_selected(index, change_level=true):
	type = index
	
	
func correct_answer(value):
	data.correct_answer = value



func _on_spin_box_2_value_changed(value):
	group = value


func _on_text_pressed():
	if $Window.visible:
		$Window.hide()
	else:
		$Window.popup()


func _on_window_close_requested():
	$Window.hide()

func _on_picture_btn_pressed():
	$PopupPanel.show()

func _on_error_box_value_changed(value):
	data.error = value


func _on_part2_item_selected(index, change_level=true):
	part = index
	




func _on_create_book_pressed():
	$information.popup_centered()
