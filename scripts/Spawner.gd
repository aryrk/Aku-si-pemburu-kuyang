extends Node3D

@export var player: Node3D
var enemy_scene = preload("res://assets/objects/enemy_endless.tscn")

var rnd = RandomNumberGenerator.new()

func _ready():
	GameStat.set_param({"kuyang_terbunuh":0})

func spawn_enemy_randomly():
	rnd.randomize()
	# Get player's position and adjust randomly
	var player_pos = player.global_transform.origin
	var random_x = player_pos.x + rnd.randf_range(-25, 25)
	var random_z = player_pos.z + rnd.randf_range(-25, 25)
	var random_y = rnd.randf_range(2, 8)  # Random y value between 2 and 8

	# Create a new position vector with the random coordinates
	var pos = Vector3(random_x, random_y, random_z)

	# Instantiate the enemy and set its properties
	var instance = enemy_scene.instantiate()
	instance.player = player
	instance.position = pos
	add_child(instance)
	
	$Timer.wait_time = randf_range(0, 2)
