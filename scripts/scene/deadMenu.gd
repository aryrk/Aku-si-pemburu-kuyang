extends Node3D

@onready var previous_scene = SceneSwitcher.get_param("previous")

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.stop_all_sounds()


func restart_game():
	SceneSwitcher.change_scene("res://scenes/loading.tscn",{"next_scene":previous_scene})
func main_menu():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
func quit_game():
	get_tree().quit()
