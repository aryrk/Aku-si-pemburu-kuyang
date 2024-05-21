extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_anything_pressed()==true):
		switch_menu()
		
func story_mode():
	#get_tree().change_scene_to_file(MAIN)
	SceneSwitcher.change_scene("res://scenes/loading.tscn",{"next_scene":"res://scenes/main.tscn"})
func quit_game():
	get_tree().quit()

func switch_menu():

	var Splash = get_node("2D element/Splash Screen")
	var Menu = get_node("2D element/Menu")

	Splash.hide()
	Menu.show()

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			switch_menu()
