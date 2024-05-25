extends Control
@onready var timer = $Timer
@onready var animation = $AnimationPlayer

func randomize_timer():
	timer.wait_time = randf_range(60,300)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_timer()



func _on_timer_timeout():
	animation.play("lightning")
	Audio.play("assets/sounds/effect/Lightning/lightning"+str(randi_range(1,2))+".mp3")
	randomize_timer()
