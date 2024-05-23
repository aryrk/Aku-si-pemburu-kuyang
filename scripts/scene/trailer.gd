extends Node3D

func go_to_main_menu():
	SceneSwitcher.change_scene("res://scenes/mainMenu.tscn")
func _process(_delta):
	if (Input.is_anything_pressed()==true):
		go_to_main_menu()
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			go_to_main_menu()

func _on_animation_player_animation_finished(_anim_name):
	go_to_main_menu()
