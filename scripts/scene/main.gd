extends Node3D

const WIN = "res://scenes/boss fight.tscn"
const EnemyScene = preload("res://assets/objects/enemy.tscn")

var enemies

func _ready():
	enemies = get_node("Enemies")
	for i in range(1, 21):
		var enemy_node = enemies.get_node_or_null("enemy-flying" + str(i))
		if enemy_node:
			print("Enemy found: ", enemy_node.name)
		else:
			print("Enemy node not found at index: ", i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$"2D element/Helper".text = str(enemies.get_child_count()) + " kuyang tersisa"
	if enemies and enemies.get_child_count() == 0:
		$"2D element/AnimationTree".play("goal_achieved")

	if enemies and enemies.get_child_count() == 10:
		for enemy in enemies.get_children():
			if enemy and "chasing_player" in enemy:
				enemy.chasing_player = true

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "goal_achieved":
		GameStat.release_mouse()
		SceneSwitcher.change_scene(WIN)
