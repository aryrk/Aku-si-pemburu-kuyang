extends Node

func load_json(path: String):
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())

		return parsedResult

func save_json(path: String, array: Array):
	var jsonString = JSON.stringify(array)
	var dataFile = FileAccess.open(path, FileAccess.WRITE)
	dataFile.store_string(jsonString)
	dataFile.close()
	
func save_json_dict(path: String, data: Dictionary):
	var jsonString = JSON.stringify(data)
	var dataFile = FileAccess.open(path, FileAccess.WRITE)
	dataFile.store_string(jsonString)
	dataFile.close()
