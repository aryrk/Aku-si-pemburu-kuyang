extends Node3D

@export var enemy_scene: PackedScene  # Export this so you can set it in the Godot editor
@export var player: Node3D  # Reference to the player node

func _ready():
	spawn_enemy()  # Spawn the first enemy when ready

func spawn_enemy():
	var enemy = enemy_scene.instance()  # Create an instance of the enemy
	enemy.player = player  # Set the enemy's player property
	add_child(enemy)  # Add the enemy as a child of the spawner
	enemy.connect("destroyed", self, "_on_enemy_destroyed")  # Connect the 'destroyed' signal to a local method
	enemy.global_transform.origin = calculate_spawn_position()  # Set the spawn position

func _on_enemy_destroyed():
	spawn_enemy()  # Spawn a new enemy when one is destroyed

func calculate_spawn_position() -> Vector3:
	# This method will determine where the enemy should spawn
	return Vector3(randf_range(-10, 10), 0, randf_range(-10, 10))  # Random position around the spawner
