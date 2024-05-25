extends Node3D

const WIN = "res://scenes/credit.tscn"

var enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	# Pastikan bahwa path ke node 'Enemies' benar
	enemies = get_node("Enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"2D element/Helper".text = str(enemies.get_child_count()) + " kuyang tersisa"
	if enemies and enemies.get_child_count() == 0:
		
		$"2D element/AnimationTree".play("goal_achieved")


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "goal_achieved":
		GameStat.release_mouse()
		SceneSwitcher.change_scene("res://scenes/credit.tscn")
