extends Node
var save_path = "user://data.cfg"

func load_level(part, level):
	var l = ["خرازی", "تورجی زاده", "کاظمی", "حجازی", "زاهدی", "نیلفروشان"]
	if FileAccess.file_exists("res://files/"+l[part]+"/level_"+str(level)+".json"):
		var file = FileAccess.open("res://files/"+l[part]+"/level_"+str(level)+".json", FileAccess.READ)
		return JSON.parse_string(file.get_as_text())
	return {}
func random_pos(Rect_range:Rect2, sub_range=Rect2(0, 0, 0, 0)) -> Vector2:
	print_stack()
	randomize()
	var x
	var y
	var z
	var n
	if sub_range.size != Vector2.ZERO:
		z = randi_range(0, 1)
		n = randi_range(0, 1)
	if z == null:
		x = randf_range(Rect_range.position.x, Rect_range.end.x)
	elif z == 0:
		x = randf_range(Rect_range.position.x, sub_range.position.x)
	elif z == 1:
		x = randf_range(sub_range.end.x, Rect_range.end.x)
	if n == null:
		y = randf_range(Rect_range.position.y, Rect_range.end.y)
	elif n == 0:
		y = randf_range(Rect_range.position.y, sub_range.position.y)
	elif n == 1:
		y = randf_range(sub_range.end.y, Rect_range.end.y)
	return Vector2(x, y)
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func multy_save(data:Dictionary):
	var confige = ConfigFile.new()
	confige.load(save_path)
	for _name in data.keys():
		confige.set_value("user", _name, data.get(_name))
	confige.save(save_path)
	
func load_game(_name, defaulte=null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	if confige.has_section_key("user", _name):
		return confige.get_value("user", _name, defaulte)
	else:
		save(_name, defaulte)
		return defaulte
