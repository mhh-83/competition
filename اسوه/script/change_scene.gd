extends CanvasLayer

var next_scene = "res://scenes/start.tscn"
var progress = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	pass
func _process(delta):
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	$ProgressBar.value = progress[0]
	if progress[0] >= 1.0:
		$ProgressBar.hide()
		get_tree().get_root().add_child(ResourceLoader.load_threaded_get(next_scene).instantiate())
		
		await get_tree().create_timer(1).timeout
		
		hide()
	
func emitting(e, path=""):
	if e:
		next_scene = path
		show()
		$AnimatedSprite2D.play("default")
	#if e:
		#set_tween(Vector2(400, -90))
	#else:
		#set_tween(UpdateData.random_pos(Rect2(-2500, -500, get_viewport().size.x + 4000, get_viewport().size.y + 1000), Rect2(-2200, 0, get_viewport().size.x + 3200, get_viewport().size.y)))
func set_tween(target):
	var tween = create_tween()
	tween.tween_property($WigglyAppendage2D, "position", target, 0.5)
	tween.set_ease(Tween.EASE_OUT)
	tween.play()
	


func _on_animated_sprite_2d_animation_finished():
	$ProgressBar.show()
	ResourceLoader.load_threaded_request(next_scene)
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	for child in get_tree().get_root().get_children():
		if child != AddBee and child != Exit  and child != UpdateData and child != Sound and child != self and not child is HTTPRequest:
			child.queue_free()
