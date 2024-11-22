extends Control

var texture 
@export var words :Array[String]
@export var _name :String
@export var _family :String
var win = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if texture:
		texture.position = Vector2(60, 50)
		texture.size = $TextureRect2.size - Vector2(150, 150)
		$TextureRect2.add_child(texture)
	var name2 = ""
	var family2 = ""
	for word in _name:
		if word != " " and word != "‌":
			name2 += word
	for word in _family:
		if word != " " and word != "‌":
			family2 += word
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	for word in name2:
		
		var btn = $Button2.duplicate()
		btn.show()
		btn.disabled = true
		btn.add_to_group("answer_word")
		btn.add_to_group("answer_name")
		btn.pressed.connect(func():
			btn.disabled = true
			btn.text = ""
			btn.current_button.disabled = false
			btn.current_button = null
			
		)
		hbox.add_child(btn)
		$HBoxContainer.add_child(hbox)
	var hbox2 = HBoxContainer.new()
	hbox2.alignment = BoxContainer.ALIGNMENT_CENTER
	for word in family2:
		
		var btn = $Button2.duplicate()
		btn.show()
		btn.disabled = true
		btn.add_to_group("answer_word")
		btn.add_to_group("answer_family")
		btn.pressed.connect(func():
			btn.disabled = true
			btn.text = ""
			btn.current_button.disabled = false
			btn.current_button = null
			
		)
		hbox2.add_child(btn)
		$HBoxContainer.add_child(hbox2)
	for word in words:
		var btn = $Button.duplicate()
		btn.show()
		btn.text = word
		btn.pressed.connect(func():
			
			for box in get_tree().get_nodes_in_group("answer_word"):
				if box.text == "":
					box.text = word
					btn.disabled = true
					box.disabled = false
					box.current_button = btn
					break
			var all_fill = true
			for box in get_tree().get_nodes_in_group("answer_word"):
				if box.text =="":
					all_fill = false
			if all_fill:
				var n = ""
				var f = ""
				for box in get_tree().get_nodes_in_group("answer_name"):
					n += box.text
				for box in get_tree().get_nodes_in_group("answer_family"):
					f += box.text
				if f == family2 and n == name2:
					win = true
					print(win)
		)
		$GridContainer.add_child(btn)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
