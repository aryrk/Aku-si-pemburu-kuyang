extends Node3D
@onready var player := $home/AudioStreamPlayer


func _on_area_3d_body_entered(body):
	if body.name == "Player":
		player.play()
