extends CanvasLayer


func _on_health_updated(health, mana):
	$health.value = health
	$mana.value = mana
