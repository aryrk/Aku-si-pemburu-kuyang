extends Node3D
var main_scene = preload("res://scenes/main.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			
			get_tree().change_scene_to_packed(main_scene)
