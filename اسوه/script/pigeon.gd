extends Node2D
var s
var t
func start(start_pos, target_pos):
	s = start_pos
	t = target_pos
func _ready():
	global_position = s
	if s.x < t.x:
		$AnimatedSprite2D.flip_h = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", t, 3)
	tween.set_ease(Tween.EASE_OUT)
	tween.play()
	await tween.finished
	$AnimatedSprite2D.play("sitdown")
	show_behind_parent = true
	$AnimatedSprite2D.flip_h = true
