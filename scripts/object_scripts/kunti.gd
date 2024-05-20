extends Node3D
@onready var timer := $Timer
@onready var jumpscare := get_node("Jumpscare")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		Audio.play("assets/sounds/Kunti Jumpscare.mp3")
		Audio.play("assets/sounds/Rumore Cinnematic Impacts/HAL9K - Scream.wav")
		jumpscare.show()
		timer.wait_time = 1
		timer.start()
	
func remove_jumpscare():
	jumpscare.hide()
	queue_free()
