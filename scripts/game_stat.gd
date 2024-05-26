extends Node

var _params = null

func set_param(params):
	_params = params

func get_param(param_name):
	if _params != null and _params.has(param_name):
		return _params[param_name]
	return null

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false
	
func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
