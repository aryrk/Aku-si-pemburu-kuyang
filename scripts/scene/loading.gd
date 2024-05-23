extends Node3D
@onready var progres := $ProgressBar
@onready var timer := $Timer

@onready var next_scene = SceneSwitcher.get_param("next_scene")

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.stop_all_sounds()
	Audio.play("assets/sounds/dramatic drum.mp3")
	var random_num = randi_range(1,3)
	
	match random_num:
		1:
			get_node("Sapu Lidi").show()
			get_node("Sapu Lidi/HUD").show()
		2:
			get_node("Kuyang").show()
			get_node("Kuyang/HUD").show()
		3:
			get_node("Pistol").show()
			get_node("Pistol/HUD").show()



func _on_timer_timeout():
	if progres.value < 100:
		progres.value+=1
		timer.wait_time=randf_range(0.02,0.05)
		timer.start()
	else:
		get_tree().change_scene_to_file(next_scene)
