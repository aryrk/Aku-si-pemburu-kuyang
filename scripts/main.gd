extends Node3D

const WIN = "res://scenes/credit.tscn"

var enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	# Pastikan bahwa path ke node 'Enemies' benar
	enemies = get_node("Enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemies and enemies.get_child_count() == 0:
		get_tree().change_scene_to_file(WIN)
