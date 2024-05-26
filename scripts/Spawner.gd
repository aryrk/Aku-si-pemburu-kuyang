extends Node3D

@export var player: Node3D

var mynode = preload("res://assets/objects/enemy_endless.tscn")

func _ready():
	spawn_enemy(Vector3(0, 2, 0))
	spawn_enemy(Vector3(10, 2, 20))
	
func spawn_enemy(pos):
	var instance = mynode.instantiate()
	instance.player = player
	instance.position = pos
	add_child(instance)
