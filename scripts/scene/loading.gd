extends Node3D
@onready var progres := $ProgressBar
@onready var timer := $Timer
@onready var heading := $HUD/Heading
@onready var subHeading := $HUD/SubHeading
@onready var richTextDesc := $HUD/RichTextLabel

@onready var next_scene = SceneSwitcher.get_param("next_scene")

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.stop_all_sounds()

	var data = Tools.load_json("res://assets/data/loading_list.json")

	var random_num = randi_range(0, data.size() - 1)

	get_node(data[random_num]["node"]).show()
	heading.text = data[random_num]["heading"]
	subHeading.text = data[random_num]["subHeading"]
	richTextDesc.text = data[random_num]["desc"]
	
	Audio.play("assets/sounds/dramatic drum.mp3")
	
func _on_timer_timeout():
	if progres.value < 100:
		progres.value += randi_range(0,3)
		timer.wait_time = randf_range(0.02, 0.05)
		timer.start()
	else:
		get_tree().change_scene_to_file(next_scene)
