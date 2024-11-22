class_name TriangleButton
extends Polygon2D
signal pressed
signal released
signal hover
signal exit_point
var triangles = []
var filter = ""
func get_pos():
	var inside = false
	for triangle in triangles:
		var v0 : Vector2 = triangle[2] - triangle[0]
		var v1 : Vector2 = triangle[1] - triangle[0]
		var v2 : Vector2 = get_global_mouse_position() - triangle[0]
		var dot00 = v0.dot(v0)
		var dot01 = v0.dot(v1)
		var dot02 = v0.dot(v2)
		var dot11 = v1.dot(v1)
		var dot12 = v1.dot(v2)
		var invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
		var u = (dot11 * dot02 - dot01 * dot12) * invDenom
		var v = (dot00 * dot12 - dot01 * dot02) * invDenom
		if (u >= 0) and (v >= 0) and (u + v < 1):
			inside = true
	return inside
func _input(event):
	if !get_tree().has_group(filter):
		if event is InputEventMouse:
			if get_pos():
				emit_signal("hover")
			else:
				emit_signal("exit_point")
		if event is InputEventMouseButton:
			if get_pos() and event.pressed:
				emit_signal("pressed")
			if get_pos() and event.is_released():
				emit_signal("released")
	else:
		emit_signal("exit_point")
func add_triangle(triangle:Triangle):
	triangles.append(triangle.get_pos())
func remove_triangle(triangle:Triangle):
	if triangles.has(triangle):
		triangles.erase(triangle.get_pos())
func clear():
	triangles = []
