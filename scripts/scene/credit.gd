extends Node3D

func _on_animation_player_animation_finished(anim_name):
	SceneSwitcher.change_scene("res://scenes/Splash Screen.tscn")
	return
