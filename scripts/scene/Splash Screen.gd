extends Node3D
@onready var player := $AudioStreamPlayer2D
@onready var current := 0
@onready var max :int = 3
@onready var timer := $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = current+2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if current > 0:
		for i in range(1,current+1):
			get_node("Control/"+str(i)).hide()
			
	
	current+=1
	if(get_node("Control/"+str(current)) == null):
		SceneSwitcher.change_scene("res://scenes/mainMenu.tscn")
		return
	get_node("Control/"+str(current)).show()
	player.stream = load("res://assets/sounds/Splash/Drum"+str(current)+".mp3")
	player.play()
	timer.wait_time = current+2
	
