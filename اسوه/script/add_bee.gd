extends Node

var touch = true
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randi_range(0, 100) == 1:
		get_tree().get_root().call_deferred("add_child", preload("res://scenes/bees.tscn").instantiate())
	
