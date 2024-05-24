extends Node

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false
	
func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
