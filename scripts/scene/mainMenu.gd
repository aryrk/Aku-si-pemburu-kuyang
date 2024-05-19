extends Node3D

const MAIN = preload("res://scenes/main.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_anything_pressed()==true):
		get_tree().change_scene_to_packed(MAIN)
