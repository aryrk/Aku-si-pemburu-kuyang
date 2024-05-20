extends Node3D
const MAIN = "res://scenes/mainMenu.tscn"
const GAME = "res://scenes/main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart_game():
	get_tree().change_scene_to_file(GAME)
func main_menu():
	get_tree().change_scene_to_file(MAIN)
func quit_game():
	get_tree().quit()
