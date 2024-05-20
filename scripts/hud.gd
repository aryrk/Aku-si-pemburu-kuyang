extends CanvasLayer
var red_tint
var timer_red_tint
func _ready():
	red_tint = get_node("RedTint")
	timer_red_tint = $DamageTimer

func _on_health_updated(health, mana):
	if $health.value > health:
		add_red_tint()
	$health.value = health
	$mana.value = mana

func add_red_tint():
	Audio.play("assets/sounds/steam.mp3")
	red_tint.show()
	timer_red_tint.start()

func remove_red_tint():
	red_tint.hide()
