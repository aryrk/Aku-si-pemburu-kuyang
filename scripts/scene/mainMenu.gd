extends Node3D

const MAIN = preload("res://scenes/main.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_anything_pressed()==true):
		# get node
		var Splash = get_node("2D element/Splash Screen")
		var Menu = get_node("2D element/Menu")

		Splash.hide()
		Menu.show()
func story_mode():
	get_tree().change_scene_to_packed(MAIN)
func quit_game():
	get_tree().quit()
