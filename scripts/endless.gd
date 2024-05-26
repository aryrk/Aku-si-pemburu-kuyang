extends Node3D

var enemies

func _ready():
	enemies = get_node("/root/Main/Spawner")

func _process(delta):
	if enemies and enemies.get_child_count() == 0:
		enemies.spawn_enemy_randomly()
		enemies.spawn_enemy_randomly()
