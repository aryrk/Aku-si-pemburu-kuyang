extends Node3D

@export var player: Node3D
@export var following_player: bool = true
@export var immune_to_mana: bool = true

@onready var raycast = $RayCast
@onready var transform_point = $"."
@onready var animation := $AnimationPlayer

var health := 10000
var hits_received := 0
var hits_received_max := 10  # Global variable to track the hit phase threshold
var max_damage_taken := 500
var base_speed := 3.5 # Base speed of the boss
var speed_increment := 0.5
var max_speed := 5.0 # Global variable to track the maximum movement speed
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
	
	$HUD/Health.max_value = health
	$HUD/Health.value = health

func _process(delta):
	if destroyed:
		return
	# Calculate the distance to the player
	var distance_to_player = position.distance_to(player.position)
	self.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP)
	
	# Movement modulation
	target_position.x += (sin(time * 5) * 1) * delta # Left and right
	target_position.y += (cos(time * 5) * 1) * delta # Up and down
	time += delta
	
	if distance_to_player < 3.0:
		target_position.y = max(target_position.y, player.position.y)

	if distance_to_player > 1.6:
		# Direction towards the player
		var direction = (player.position - position).normalized()
		# New speed calculation
		var new_speed = min(base_speed + speed_increment, max_speed)
		target_position += direction * new_speed * delta
	
	transform_point.rotation_degrees.y += 180
	position = target_position

func damage(amount, use_mana):
	if use_mana and immune_to_mana:
		animation.play("shield")
		return
	amount = min(amount, max_damage_taken)
	health -= amount
	hits_received += 1
	$HUD/Health.value = health

	if health <= 0 and not destroyed:
		destroy()

	# Check health to adjust enemy behavior
	check_health_phase()
	if hits_received % hits_received_max == 0:
		random_teleport()
		chasing_player = true # Start chasing the player after being hit

func check_health_phase():
	if health <= 10000 * 0.3: # Phase 3
		max_speed = 8
		hits_received_max = 2
	elif health <= 10000 * 0.6: # Phase 2
		max_speed = 4
		hits_received_max = 8
	elif health <= 10000 * 0.8: # Phase 1
		max_speed = 3
		hits_received_max = 10

func random_teleport():
	Audio.play("assets/sounds/effect/Glitch/Glitch" + str(randi_range(1, 12)) + ".mp3")
	animation.play("teleport")
	var player_pos = player.position
	var random_x = player_pos.x + rnd.randf_range(-15, 15)
	var random_z = player_pos.z + rnd.randf_range(-15, 15)
	target_position = Vector3(random_x, position.y, random_z)
	base_speed += speed_increment

func destroy():
	Audio.play("assets/sounds/Scary Sound Effects (Horror Scream).mp3")
	destroyed = true
	queue_free()

func moan():
	if not audio_stream.playing:
		audio_stream.stream = load("assets/sounds/Laugh/Laugh" + str(randi_range(1, 5)) + ".mp3")
		audio_stream.play()
		timer_moan.wait_time = randf_range(3, 7)

func _on_timer_timeout():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.has_method("damage"):
			collider.damage(5)

func _on_timer_hit_received_cd_timeout():
	pass
