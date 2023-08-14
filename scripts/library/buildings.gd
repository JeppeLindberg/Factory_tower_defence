
const _json_path = "res://scripts/library/buildings.json"

var buildings_dict = null


# Read all information about buildable objects, and return them as a dict
func get_all_buildings():
	if buildings_dict != null:
		return buildings_dict

	var buildings_file = FileAccess.open(_json_path, FileAccess.READ)
	var buildings_data = buildings_file.get_as_text()
	buildings_dict = JSON.parse_string(buildings_data)
	return buildings_dict

# Return the information of a certain building
func get_building_by_name(name):
	return get_all_buildings()[name]
