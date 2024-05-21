extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart_game():
	SceneSwitcher.change_scene("res://scenes/loading.tscn",{"next_scene":"res://scenes/main.tscn"})
func main_menu():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
func quit_game():
	get_tree().quit()
