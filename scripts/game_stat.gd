extends Node

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false
	
