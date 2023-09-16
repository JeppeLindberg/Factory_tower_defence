
const _json_path = "res://scripts/library/enemy_waves.json"

var waves_dict = null


# Read all information about enemy waves objects, and return them as a dict
func get_all_waves():
	if waves_dict != null:
		return waves_dict

	var waves_file = FileAccess.open(_json_path, FileAccess.READ)
	var waves_data = waves_file.get_as_text()
	waves_dict = JSON.parse_string(waves_data)
	return waves_dict

# Return the information of a certain wave
func get_wave_by_index(index):
	return get_all_waves()[str(index)]
