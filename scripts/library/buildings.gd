
const _json_path = "res://scripts/library/buildings.json"

func get_all_buildings():
	var buildings_file = FileAccess.open(_json_path, FileAccess.READ)
	var buildings_data = buildings_file.get_as_text()
	var buildings_dict = JSON.parse_string(buildings_data)
	return buildings_dict

func get_building_by_name(name):
	var buildings_dict = get_all_buildings()
	return buildings_dict[name]
