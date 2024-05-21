extends AudioStreamPlayer3D

var timer

func _ready():
	timer = $SoundTimer
	randomize_player_timeout()
func randomize_player_timeout():
	timer.wait_time = randf_range(45, 300)

func _process(delta):
	pass

func _on_sound_timer_timeout():
	if is_playing():
		return
	var audio_stream: AudioStream = load("assets/sounds/effect/Owl/owl" + str(randi_range(1, 2)) + ".mp3")
	set_stream(audio_stream)
	play()
	randomize_player_timeout()
