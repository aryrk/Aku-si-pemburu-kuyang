extends CanvasLayer
var red_tint
var timer_red_tint
func _ready():
	red_tint = get_node("Damage_taken/RedTint")
	timer_red_tint = $Damage_taken/DamageTimer

func _on_health_updated(health, mana):
	if $Stat/health.value > health:
		add_red_tint()
	$Stat/health.value = health
	$Stat/mana.value = mana

func add_red_tint():
	Audio.play("assets/sounds/steam.mp3")
	red_tint.show()
	timer_red_tint.start()
	$"Damage_taken/Blur anim".play("blur")

func remove_red_tint():
	red_tint.hide()


func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	GameStat.resume()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
