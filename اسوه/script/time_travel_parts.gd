extends Control

var points = []
var unlock_part = 1
var count = 0
func add_point(point, line:Line2D, num):
	line.points = []
	for x in range(point.size()):
	
		if x < point.size() - 1:
			var a = point[x]
			var b = point[x + 1]
			if x == 0:
				line.add_point(a)
			for y in range(num):
				var c = a + (a.direction_to(b) * (y * ((b - a).length() / float(num))))
				if (c - a).length() > 3:
					line.add_point(c)
			line.add_point(b)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	unlock_part = UpdateData.load_game("unlock_part", 0)
	for y in range($buttons.get_children().size()):
		var button = $buttons.get_child(y)
		button.text = str(button.get_meta("part") + 1)
		button.pressed.connect(_on_button_pressed.bind(button.get_meta("part")))
		if unlock_part < y:
			button.disabled = true
		elif unlock_part > y:
			button.get_node("Sprite2D").show()
		

func _on_button_pressed(part):
	UpdateData.save("part", part)
	add_child(preload("res://scenes/levels.tscn").instantiate())


func _on_back_button_pressed():
	if get_tree().has_group("main"):
		get_tree().get_nodes_in_group("main")[0].show()
	queue_free()
