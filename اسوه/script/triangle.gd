class_name Triangle

extends Node
var A = Vector2.ZERO
var B = Vector2.ZERO
var C = Vector2.ZERO

func _init(a:Vector2, b:Vector2, c:Vector2):
	A = a
	B = b
	C = c
func get_pos():
	return [A, B, C]
