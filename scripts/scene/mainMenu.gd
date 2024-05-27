extends Node3D
@onready var ready_to_load = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var streamer = GameStat.get_user_data()["streamer"]
	if streamer:
		$"2D element/Menu/CheckBox".button_pressed = true
		$AudioStreamPlayer2D.stream_paused = true
	else:
		$"2D element/Menu/CheckBox".button_pressed = false
	ready_to_load = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_anything_pressed()==true):
		switch_menu()
		
func story_mode():
	#get_tree().change_scene_to_file(MAIN)
	SceneSwitcher.change_scene("res://scenes/loading.tscn",{"next_scene":"res://timeline/opening.tscn"})
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


func _on_credit_pressed():
	SceneSwitcher.change_scene("res://scenes/credit.tscn")


func _on_endless_pressed():
	SceneSwitcher.change_scene("res://scenes/loading.tscn",{"next_scene":"res://scenes/endless.tscn"})


func _on_check_box_toggled(toggled_on):
	if not ready_to_load:
		return
	GameStat.save_user_data(toggled_on)
	if toggled_on:
		$AudioStreamPlayer2D.stream_paused = true
	else:
		$AudioStreamPlayer2D.stream_paused = false
