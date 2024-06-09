extends CharacterBody3D

@export_subgroup("Properties")
@export var player_movement_speed = 5
@export var jump_strength = 8

@export_subgroup("Weapons")
@export var weapons: Array[Weapon] = []

var weapon: Weapon
var weapon_index := 0

var mouse_sensitivity = 700
var gamepad_sensitivity := 0.075

var mouse_captured := true

var movement_velocity: Vector3
var rotation_target: Vector3

var input_mouse: Vector2

var alive = true
var health: int = 100
var mana: int = 100
var maxMana: int = 100
var is_healing: bool = false
var maxHealth: int = 100
var gravity := 0.0

var previously_floored := false

var jump_single := true
var jump_double := true

var container_offset = Vector3(1.2, -1.1, -2.75)

var tween: Tween

const DEAD_MENU = "res://scenes/dead.tscn"
@onready var current_scene = get_tree().current_scene.scene_file_path

@onready var items_bar = $HUD/Items


# var max_ammo: int = 10
# var current_ammo: int = max_ammo
# var reload_time: float = 0
# var is_reloading: bool = false

signal health_updated

@onready var camera = $Head/Camera
@onready var raycast = $Head/Camera/RayCast
@onready var muzzle = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Muzzle
@onready var container = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Container
@onready var sound_footsteps = $SoundFootsteps
@onready var blaster_cooldown = $Cooldown

@onready var crosshair = $HUD/Crosshair

# Functions

func use_weapon(index):
	var progres : ProgressBar = get_node("HUD/Items/"+str(index)+"/ProgressBar"+str(index))
	var timer : Timer = get_node("HUD/Items/"+str(index)+"/ProgressBar"+str(index)+"/Timer"+str(index))
	
	progres.value = 0
	timer.start()
	
func switch_weapon_overlay(index):
	var i = 0
	for weapon_num in weapons:
		var overlay :Sprite2D = get_node("HUD/Items/"+str(i)+"/ProgressBar"+str(i)+"/Sprite2D"+str(i))
		if i == index:
			overlay.show_behind_parent = false
		else :
			overlay.show_behind_parent = true
		i+=1

func weapon_cooldown(progres:ProgressBar, timer:Timer):
	if progres.value < progres.max_value:
		progres.value+=0.1
		timer.start()

func add_weapon_to_view(index, cooldown, sprite_path):
	var weapon_control = Control.new()
	weapon_control.name = str(index)
	
	get_node("HUD/Items").add_child(weapon_control)
	
	var progress = ProgressBar.new()
	progress.name = "ProgressBar"+str(index)
	progress.max_value = cooldown
	progress.show_percentage = false
	progress.set_size(Vector2(80,80))
	progress.max_value = cooldown
	progress.value = cooldown
	progress.fill_mode = progress.FILL_BOTTOM_TO_TOP
	
	get_node("HUD/Items/"+str(index)).add_child(progress)
	
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"+str(index)
	sprite.centered = false
	sprite.apply_scale(Vector2(0.075,0.075))
	sprite.texture = load(sprite_path)
	get_node("HUD/Items/"+str(index)+"/ProgressBar"+str(index)).add_child(sprite)
	
	var weapon_timer = Timer.new()
	weapon_timer.connect("timeout",weapon_cooldown.bind(progress,weapon_timer))
	weapon_timer.wait_time = cooldown/10
	weapon_timer.one_shot = true
	weapon_timer.name = "Timer"+str(index)
	weapon_timer.autostart = false
	
	get_node("HUD/Items/"+str(index)+"/ProgressBar"+str(index)).add_child(weapon_timer)
	

func _ready():
	exit_pause_menu()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var i = 0
	for weapon_idx in weapons:
		add_weapon_to_view(i,weapon_idx.cooldown,weapon_idx.sprite)
		i+=1
	weapon = weapons[weapon_index] # Weapon must never be nil
	initiate_change_weapon(weapon_index)
	
	
	# current_ammo = max_ammo

func _physics_process(delta):
	
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	# Movement

	var applied_velocity: Vector3
	
	movement_velocity = transform.basis * movement_velocity # Move forward
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()
	
	# Rotation
	
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 25 * delta, delta * 5)
	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	container.position = lerp(container.position, container_offset - (applied_velocity / 30), delta * 10)
	
	# Movement sound
	
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			sound_footsteps.stream_paused = false
	
	# Landing after jump or falling
	
	camera.position.y = lerp(camera.position.y, 0.0, delta * 5)
	
	if is_on_floor() and gravity > 1 and !previously_floored: # Landed
		Audio.play("assets/sounds/land.ogg")
		camera.position.y = -0.1
	
	previously_floored = is_on_floor()
	
	# Falling/respawning
	
	if position.y < - 10:
		get_tree().reload_current_scene()

# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity

func go_to_pause_menu():
	get_node("HUD/Pause Menu").show()
	GameStat.pause()
	
func exit_pause_menu():
	get_node("HUD/Pause Menu").hide()
	GameStat.resume()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true

func handle_controls(_delta):
	
	if !alive:
		return
	
	# Mouse capture
	
	if Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_captured = true
		
		exit_pause_menu()
		
	if Input.is_action_just_pressed("mouse_capture_exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_captured = false
		
		input_mouse = Vector2.ZERO
		
		go_to_pause_menu()
		
	
	action_shoot()
	# if Input.is_action_just_pressed("reload"):
	# 	action_reload()
	# Movement
	if Input.is_action_just_pressed("heal"):
		is_healing = true
		action_heal()
	else:
		is_healing = false
	
	# Movement
	
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	movement_velocity = Vector3(input.x, 0, input.y).normalized() * player_movement_speed
	
	# Rotation
	
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	
	rotation_target -= Vector3( - rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * gamepad_sensitivity
	rotation_target.x = clamp(rotation_target.x, deg_to_rad( - 90), deg_to_rad(90))
	
	# Shooting
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		
		if jump_single or jump_double:
			Audio.play("assets/sounds/jump_a.ogg, assets/sounds/jump_b.ogg, assets/sounds/jump_c.ogg")
		
		if jump_double:
			
			gravity = -jump_strength
			jump_double = false
			
		if (jump_single): action_jump()
		
	# Weapon switching
	
	action_weapon_toggle()

# Handle gravity

func handle_gravity(delta):
	
	gravity += 20 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func action_jump():
	
	gravity = -jump_strength
	
	jump_single = false;
	jump_double = true;

# Shooting

func use_mana(cost):
	mana = max(0, mana - cost)
	if mana > 100:
		mana = 100
	health_updated.emit(health, mana)

func action_shoot():
	
	if Input.is_action_pressed("shoot"):
		# if is_reloading:
		# 	return
		# if current_ammo <= 0:
		# 	return
		if !blaster_cooldown.is_stopped() or (weapon.uses_mana and mana < weapon.mana_cost): return # Cooldown for shooting
		
		use_weapon(weapon_index)
		
		if weapon.uses_mana:
			use_mana(weapon.mana_cost)
		
		# current_ammo -= 1
		Audio.play(weapon.sound_shoot)
		
		container.position.z += 0.25 # Knockback of weapon visual
		camera.rotation.x += 0.025 # Knockback of camera
		movement_velocity += Vector3(0, 0, weapon.knockback) # Knockback
		
		# Set muzzle flash position, play animation
		
		muzzle.play("default")
		
		muzzle.rotation_degrees.z = randf_range( - 45, 45)
		muzzle.scale = Vector3.ONE * randf_range(0.40, 0.75)
		muzzle.position = container.position - weapon.muzzle_position
		
		blaster_cooldown.start(weapon.cooldown)
		
		# Shoot the weapon, amount based on shot count
		
		for n in weapon.shot_count:
		
			raycast.target_position.x = randf_range( - weapon.spread, weapon.spread)
			raycast.target_position.y = randf_range( - weapon.spread, weapon.spread)
			
			raycast.force_raycast_update()
			
			if !raycast.is_colliding(): continue # Don't create impact when raycast didn't hit
			
			var collider = raycast.get_collider()
			
			# Hitting an enemy
			
			if collider.has_method("damage"):
				collider.damage(weapon.damage,weapon.uses_mana)
			
				if !weapon.uses_mana:
					use_mana( - weapon.mana_gain)
			
			# Creating an impact animation
			
			var impact = preload ("res://assets/objects/impact.tscn")
			var impact_instance = impact.instantiate()
			
			impact_instance.play("shot")
			
			get_tree().root.add_child(impact_instance)
			
			impact_instance.position = raycast.get_collision_point() + (raycast.get_collision_normal() / 10)
			impact_instance.look_at(camera.global_transform.origin, Vector3.UP, true)

# func action_reload():
# 	if is_reloading:
# 		return # Prevent starting a reload if already reloading
# 	is_reloading = true
# 	Audio.play("assets/sounds/recoil.mp3")
# 	await get_tree().create_timer(reload_time).timeout
# 	current_ammo = max_ammo # Reset ammo count
# 	is_reloading = false # Finish reloading

# Toggle between available weapons (listed in 'weapons')
func action_weapon_toggle():
	
	if Input.is_action_just_pressed("weapon_toggle"):
		
		weapon_index = wrap(weapon_index + 1, 0, weapons.size())
		initiate_change_weapon(weapon_index)
		
		Audio.play("assets/sounds/weapon_change.ogg")

# Initiates the weapon changing animation (tween)

func initiate_change_weapon(index):
	
	switch_weapon_overlay(index)
	weapon_index = index
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(container, "position", container_offset - Vector3(0, 1, 0), 0.1)
	tween.tween_callback(change_weapon) # Changes the model

# Switches the weapon model (off-screen)

func change_weapon():
	
	weapon = weapons[weapon_index]

	# Step 1. Remove previous weapon model(s) from container
	
	for n in container.get_children():
		container.remove_child(n)
	
	# Step 2. Place new weapon model in container
	
	var weapon_model = weapon.model.instantiate()
	container.add_child(weapon_model)
	
	weapon_model.position = weapon.position
	weapon_model.rotation_degrees = weapon.rotation
	
	# Step 3. Set model to only render on layer 2 (the weapon camera)
	
	for child in weapon_model.find_children("*", "MeshInstance3D"):
		child.layers = 2
		
	# Set weapon data
	
	raycast.target_position = Vector3(0, 0, -1) * weapon.max_distance
	crosshair.texture = weapon.crosshair

func damage(amount):
	
	health -= amount
	health_updated.emit(health, mana) # Update health on HUD
	
	if health <= 0:
		alive=false
		$Head/Camera/AnimationPlayer.play("death")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_captured = false
		
		input_mouse = Vector2.ZERO
		
		
func action_heal():
	if mana < (maxMana/2) or health == maxHealth:
		return
	var heal_amount = 20 # Adjust the amount as needed
	use_mana(maxMana / 2)
	health = min(health + heal_amount, maxHealth)
	health_updated.emit(health, mana)
	Audio.play("assets/sounds/heal.mp3")


func _on_animation_player_animation_finished(anim_name):
	if anim_name=="death":
		SceneSwitcher.change_scene(DEAD_MENU, {"previous":current_scene})


func _on_restart_pressed():
	GameStat.resume()
	SceneSwitcher.change_scene(current_scene)
