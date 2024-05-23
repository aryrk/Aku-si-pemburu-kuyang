extends Node3D
@onready var player := $AudioStreamPlayer2D
@onready var current := 0
@onready var max_img :int = 3
@onready var timer := $Timer

func _ready():
	timer.wait_time = current+2

func _on_timer_timeout():
	if current >= max_img:
		SceneSwitcher.change_scene("res://scenes/mainMenu.tscn")
		return
	if current > 0:
		for i in range(1,current+1):
			get_node("Control/"+str(i)).hide()
			
	
	current+=1
	
	get_node("Control/"+str(current)).show()
	player.stream = load("res://assets/sounds/Splash/Drum"+str(current)+".mp3")
	player.play()
	timer.wait_time = current+2
	
