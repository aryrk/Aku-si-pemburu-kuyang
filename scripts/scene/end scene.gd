extends Node3D



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cutscene":
		SceneSwitcher.change_scene("res://scenes/credit.tscn")
