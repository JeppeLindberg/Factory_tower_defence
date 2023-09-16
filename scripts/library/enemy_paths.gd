
const _json_path = "res://scripts/library/enemy_paths.json"

var enemy_paths_dict = null


# Read all information about enemy paths, and return them as a dict
func get_all_enemy_paths():
	if enemy_paths_dict != null:
		return enemy_paths_dict

	var enemy_paths_file = FileAccess.open(_json_path, FileAccess.READ)
	var enemy_paths_data = enemy_paths_file.get_as_text()
	enemy_paths_dict = JSON.parse_string(enemy_paths_data)
	return enemy_paths_dict

# Return the path of a certain enemy by name
func get_path_by_name(name):
	return get_all_enemy_paths()[name]
