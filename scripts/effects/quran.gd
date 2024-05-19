extends Node3D

var material
var emision_energy = 0
var timer := Timer.new()
var audio_player
var hold_duration = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# get material from 'weapons' node, in Quran_Closed_001/Quran_Closed_Inner_003
	var weapons = get_node("weapons/Quran_Closed_001/Quran_Closed_Inner_003")
	material = weapons.get_active_material(0)
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = true

	audio_player = $AudioStreamPlayer
	audio_player.stream = load("assets/sounds/AYAT KURSI.mp3")
	audio_player.play()
	audio_player.stream_paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.emission_energy = emision_energy
	action_shoot(delta)
# 	start_murotal(delta)
# 	stop_emision()

# func action_shoot():
# 	if Input.is_action_pressed("shoot"):
# 		emision_energy = 16
# 		timer.start()

# func stop_emision():
# 	if timer.is_stopped():
# 		emision_energy = 0

func action_shoot(delta):
	if Input.is_action_pressed("shoot"):
		hold_duration += delta
		emision_energy = 1
			
	if Input.is_action_just_released("shoot"):
		hold_duration = 0
		emision_energy = 0
		audio_player.stream_paused = true

	if hold_duration > 0.5:
		if emision_energy < 16:
			emision_energy += 0.3
		audio_player.stream_paused = false
		if not audio_player.playing:
			audio_player.play()