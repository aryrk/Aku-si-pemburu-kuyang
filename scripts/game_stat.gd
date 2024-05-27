extends Node

var _params = null
var user_data = null

func load_user_data():
	user_data = Tools.load_json("res://assets/data/user.json")

func _ready():
	load_user_data()
	
func get_user_data():
	load_user_data()
	return user_data
	
func save_user_data(streamer):
	var json = {"streamer":streamer}
	Tools.save_json_dict("res://assets/data/user.json", json)

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
