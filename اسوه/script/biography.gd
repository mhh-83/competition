@tool
extends Control
var obj
var offset = 0
var show_pic = false
var data  = [[1, 1, 1, 1, 0, 1, 1, 1, 1, 1], [0, 1, 0, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
var col = 10
var row = 10
var mode = 1
@export var texture : Texture2D:
	set(x):
		texture = x
		if !Engine.is_editor_hint():
			await tree_entered
		$TextureRect.texture  = texture
func set_texture(tex):
	$TextureRect.texture  = tex
# Called when the node enters the scene tree for the first time.
func _ready():
	var size_x = ceil($TextureRect.size.x / float(col))
	var size_y = ceil($TextureRect.size.y / float(row))
	var part = UpdateData.load_game("part", "")
	data = UpdateData.load_game("data_"+str(part), [])
	if data is String:
		var j = JSON.new()
		data = j.parse_string(data)
		
	
	if data == []:
		for x in range(col):
			var d = []
			for y in range(row):
				d.append(0)
			data.append(d)
		UpdateData.save("data_"+str(part), data)
	
	for x in range(col):
		for y in range(row):
			var rect = TextureRect.new()
			var material_r = ShaderMaterial.new()
			material_r.shader = preload("res://shaders/kill.tres")
			rect.material = material_r
			rect.texture = preload("res://sprite/کنگره.jpg")
			rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			rect.stretch_mode = TextureRect.STRETCH_SCALE
			rect.set_meta("pos", Vector2(x, y))
			rect.size = Vector2(size_x, size_y)
			rect.position = Vector2(size_x * x, size_y * y)
			rect.add_to_group("hiden_pic")
			$TextureRect.add_child(rect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().has_group("hiden_pic"):
		if !show_pic:
			if mode == 0:
				print(offset)
				if offset == 0:
					obj = get_tree().get_nodes_in_group("hiden_pic")[randi_range(0, get_tree().get_nodes_in_group("hiden_pic").size() - 1)]
				if obj:
					offset += 1 * delta
					obj.material.set_shader_parameter("offset", offset)
					if offset >= 1.6:
						obj.queue_free()
						obj = null
						offset = 0
			else:
				offset += 1 * delta
				for j in get_tree().get_nodes_in_group("hiden_pic"):
					var pos = j.get_meta("pos")
					if data[pos.x][pos.y] == 1:
						j.material.set_shader_parameter("offset", offset)
						if offset >= 1.6:
							j.queue_free()
		else:
			offset += 1 * delta
			for j in get_tree().get_nodes_in_group("hiden_pic"):
				j.material.set_shader_parameter("offset", offset)
				if offset >= 1.6:
					j.queue_free()
		
