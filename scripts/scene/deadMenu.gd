extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.stop_all_sounds()


func restart_game():
	SceneSwitcher.change_scene("res://scenes/loading.tscn",{"next_scene":"res://scenes/main.tscn"})
func main_menu():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
func quit_game():
	get_tree().quit()
