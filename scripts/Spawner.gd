extends Node3D

@export var player: Node3D

var mynode = preload("res://assets/objects/enemy_endless.tscn")

func _ready():
	GameStat.set_param({"kuyang_terbunuh":0})
	
func spawn_enemy(pos):
	var instance = mynode.instantiate()
	instance.player = player
	instance.position = pos
	add_child(instance)
	
func spawn_at_random():
	spawn_enemy(Vector3(randi_range(-160,52),randi_range(-1,50),randi_range(-39,67)))
	$Timer.wait_time = randf_range(0,5)
