extends Node3D

var material
var emision_energy = 0
var audio_player
var timer
# var hold_duration = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# get material from 'weapons' node, in Quran_Closed_001/Quran_Closed_Inner_003
	var weapons = get_node("sapu/Cylinder_075")
	material = weapons.get_active_material(0)

	timer = $Timer

	audio_player = $AudioStreamPlayer
	# audio_player.stream = load("assets/sounds/AYAT KURSI.mp3")
	# audio_player.play()
	# audio_player.stream_paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.emission_energy = emision_energy
	action_shoot(delta)
# 	start_murotal(delta)
# 	stop_emision()


func action_shoot(_delta):
	if Input.is_action_pressed("shoot"):
		# hold_duration += delta
		emision_energy = 10
		$AnimationPlayer.play("sapu")
			
	if Input.is_action_just_released("shoot"):
		timer.start()


	# if hold_duration > 0.5:
	# 	if emision_energy < 30:
	# 		emision_energy += 0.3
	# 	audio_player.stream_paused = false
	# 	if not audio_player.playing:
	# 		audio_player.play()


func _on_timer_timeout():
	if emision_energy > 0:
		emision_energy -= 2
		timer.start()
