extends Node3D

func _ready():
	var user_data = GameStat.get_user_data()
	if user_data["streamer"]:
		$AudioStreamPlayer2D.stream_paused=true

func _on_animation_player_animation_finished(_anim_name):
	SceneSwitcher.change_scene("res://scenes/Splash Screen.tscn")
	return
