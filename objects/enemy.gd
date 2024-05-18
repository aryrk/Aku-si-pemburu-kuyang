extends Node3D

@export var player: Node3D

@onready var raycast = $RayCast
@onready var muzzle_a = $MuzzleA
@onready var muzzle_b = $MuzzleB

var health := 100
var time := 0.0
var target_position: Vector3
var destroyed := false

var rnd = RandomNumberGenerator.new()
var audio_stream
var timer_moan

# When ready, save the initial position

func _ready():
	target_position = position
	audio_stream = $AudioStreamPlayer3D
	timer_moan = $Timer_Moan
	timer_moan.wait_time = randf_range(3, 10)

func _process(delta):
	self.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP, true) # Look at player

	# functions to make the movement more smooth
	target_position.x += (sin(time * 5) * 1) * delta # Cosine movement (left and right)

	target_position.y += (cos(time * 5) * 1) * delta # Sine movement (up and down)

	time += delta

	position = target_position
	# Calculate direction towards the player
	var direction = (player.position - position).normalized()
	
	# Move towards the player
	var move_speed = 2.0
	target_position += direction * move_speed * delta

# Take damage from player

func damage(amount):
	Audio.play("sounds/ghast/hurt.mp3")

	health -= amount

	if health <= 0 and !destroyed:
		destroy()

# Destroy the enemy when out of health

func destroy():
	Audio.play("sounds/ghast/dead.mp3")

	destroyed = true
	queue_free()

# Shoot when timer hits 0

func moan():
	if rnd.randi_range(0, 1) == 0 and !audio_stream.playing:
		audio_stream.pitch_scale = randf_range(0.8, 1.2)
		audio_stream.stream = load("sounds/ghast/moan" + str(rnd.randi_range(1, 5)) + ".mp3")
		audio_stream.play()
		timer_moan.wait_time = randf_range(3, 10)

func _on_timer_timeout():

	if raycast.is_colliding():
		var collider = raycast.get_collider()

		if collider.has_method("damage"):
			collider.damage(10)

	# raycast.force_raycast_update()

	# if raycast.is_colliding():
	# 	var collider = raycast.get_collider()

	# 	if collider.has_method("damage"): # Raycast collides with player
	# 		# Play muzzle flash animation(s)

	# 		muzzle_a.frame = 0
	# 		muzzle_a.play("default")
	# 		muzzle_a.rotation_degrees.z = randf_range( - 45, 45)

	# 		muzzle_b.frame = 0
	# 		muzzle_b.play("default")
	# 		muzzle_b.rotation_degrees.z = randf_range( - 45, 45)

	# 		Audio.play("sounds/enemy_attack.ogg")

	# 		collider.damage(5) # Apply damage to player
