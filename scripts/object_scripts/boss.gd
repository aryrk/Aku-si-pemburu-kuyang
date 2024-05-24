extends Node3D

@export var player: Node3D
@export var following_player: bool = true

@onready var raycast = $RayCast
@onready var transform_point = $"."
@onready var hit_received_cd_timer: Timer = $Timer_Hit_Received_CD
@onready var animation_player = $AnimationPlayer

var health := 10000
var hits_received := 0
var max_damage_taken := 500
var base_speed := 3.5  # Base speed of the boss
var speed_increment := 0.2
var time := 0.0
var target_position: Vector3
var destroyed := false

var rnd = RandomNumberGenerator.new()
var audio_stream
var timer_moan

var wander_timer = 0.0
var wander_interval = randf_range(2.0, 6.0)
var wander_direction = Vector3()
var chasing_player = false

# When ready, save the initial position
func _ready():
	target_position = position
	audio_stream = $AudioStreamPlayer3D
	timer_moan = $Timer_Moan
	timer_moan.wait_time = randf_range(3, 10)
	hit_received_cd_timer.wait_time = 0.2
	hit_received_cd_timer.one_shot = true

func _process(delta):
	# Calculate the distance to the player
	var distance_to_player = position.distance_to(player.position)
	
	# Functions to make the movement more smooth
	target_position.x += (sin(time * 5) * 1) * delta # Cosine movement (left and right)
	target_position.y += (cos(time * 5) * 1) * delta # Sine movement (up and down)
	time += delta
	

	# Maintain y-axis position to be at least the player's y-axis position
	target_position.y = max(target_position.y, player.position.y)
	if distance_to_player > 0.5:
		# Look at player
		self.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP)
		
		# Calculate direction towards the player
		var direction = (player.position - position).normalized()
		# Move towards the player
		target_position += direction * base_speed * delta
	# Update the position of the enemy
	transform_point.rotation_degrees.y += 180
	position = target_position

func damage(amount):
	if not hit_received_cd_timer.is_stopped():  # Check if cooldown is active
		return  # Ignore hits during cooldown
	amount = min(amount, max_damage_taken)  # Limit the damage taken to max_damage_taken
	Audio.play("assets/sounds/ghast/hurt.mp3")
	health -= amount
	hits_received += 1
	hit_received_cd_timer.start()  # Start cooldown timer

	if health <= 0 and not destroyed:
		destroy()

	# Every 8 hits, teleport to a random location
	if hits_received % 8 == 0:
		random_teleport()
		chasing_player = true  # Start chasing the player after being hit

func random_teleport():
	animation_player.play("pre_tele")  # Play the pre-teleport animation
	await animation_player.animation_finished  # Wait for the animation to finish
	
	var random_x = rnd.randf_range(-20, 20)
	var random_z = rnd.randf_range(-20, 20)
	target_position = Vector3(random_x, position.y, random_z)
	base_speed += speed_increment

	# Now, the enemy has teleported, trigger the post-teleport animation
	animation_player.play("post_tele")

func destroy():
	Audio.play("assets/sounds/ghast/dead.mp3")
	destroyed = true
	queue_free()

func moan():
	if rnd.randi_range(0, 1) == 0 and not audio_stream.playing:
		audio_stream.pitch_scale = randf_range(0.8, 1.2)
		audio_stream.stream = load("assets/sounds/ghast/moan" + str(rnd.randi_range(1, 5)) + ".mp3")
		audio_stream.play()
		timer_moan.wait_time = randf_range(3, 10)

func _on_timer_timeout():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.has_method("damage"):
			collider.damage(20)

func _on_timer_hit_received_cd_timeout():
	pass 