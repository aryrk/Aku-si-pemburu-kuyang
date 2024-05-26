extends Node3D

@export var player: Node3D

@onready var raycast = $RayCast
@onready var transform_point = $"."
@export var immune_to_mana: bool = false

var health := 100
var time := 0.0
var target_position: Vector3
var destroyed := false

var rnd = RandomNumberGenerator.new()
var audio_stream
var timer_moan
var base_speed := 4.0  # Initial base speed

# When ready, save the initial position
func _ready():
	target_position = position
	audio_stream = $AudioStreamPlayer3D
	timer_moan = $Timer_Moan
	timer_moan.wait_time = randf_range(3, 10)

func _process(delta):
	# Calculate the distance to the player
	var distance_to_player = position.distance_to(player.position)
	
	# Functions to make the movement more smooth
	target_position.x += (sin(time * 5) * 1) * delta # Cosine movement (left and right)
	target_position.y += (cos(time * 5) * 1) * delta # Sine movement (up and down)
	time += delta

	# Maintain y-axis position to be at least the player's y-axis position, but only if within 3 meters
	if distance_to_player < 3.0:
		target_position.y = max(target_position.y, player.position.y)

	if distance_to_player > 0.5:  # Check if the distance is more than 0.5 meters
		# Look at player
		self.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP, true)
		
		# Calculate direction towards the player
		var direction = (player.position - position).normalized()
		
		# Move towards the player
		target_position += direction * base_speed * delta

	# Update the position of the enemy
	position = target_position

# Take damage from player
func damage(amount,use_mana):
	if use_mana and immune_to_mana:
		return
	Audio.play("assets/sounds/ghast/hurt.mp3")
	health -= amount

	if health <= 0 and !destroyed:
		destroy()

# Destroy the enemy when out of health
func destroy():
	var params = GameStat.get_param("kuyang_terbunuh")
	params+=1
	GameStat.set_param({"kuyang_terbunuh":params})
	get_node("../../2D element/Helper").text = str(params)+" kuyang terbunuh"
	Audio.play("assets/sounds/ghast/dead.mp3")
	destroyed = true
	queue_free()
	base_speed += 0.002

# Shoot when timer hits 0
func moan():
	if rnd.randi_range(0, 1) == 0 and !audio_stream.playing:
		audio_stream.pitch_scale = randf_range(0.8, 1.2)
		audio_stream.stream = load("assets/sounds/ghast/moan" + str(rnd.randi_range(1, 5)) + ".mp3")
		audio_stream.play()
		timer_moan.wait_time = randf_range(3, 10)

func _on_timer_timeout():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.has_method("damage"):
			collider.damage(5)
