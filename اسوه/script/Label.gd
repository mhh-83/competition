extends RichTextLabel
signal mouse_hover
signal mouse_exit
var hover = false
var size2 = 70
var t1 = TriangleButton.new()
var t2 = TriangleButton.new()
func set_triangle():
	t1.clear()
	t2.clear()
	t1.add_triangle(Triangle.new(global_position, Vector2(global_position.x + size.x, global_position.y), Vector2(global_position.x, global_position.y + size.y)))
	t2.add_triangle(Triangle.new(global_position, Vector2(global_position.x, global_position.y + size.y), global_position + size))
func _ready():
	add_theme_font_size_override("normal_font_size", size2)
	pivot_offset = size / 2
	set_triangle()
	for x in range(2):
		var z = get("t"+str(x + 1))
		z.filter = "levels"
		z.hover.connect(_on_hover)
		z.pressed.connect(_on_pressed)
		z.exit_point.connect(_on_mouse_exited)
		add_child(z)

func _process(delta):
	set_triangle()


func _on_mouse_exited():
	emit_signal("mouse_exit", self)
	hover = false


	
func _on_hover():
	emit_signal("mouse_hover", self)
	hover = true


func _on_pressed():
	emit_signal("mouse_hover", self)
	scale = Vector2.ONE * 1.1
	add_theme_color_override("default_color", Color("000092"))
