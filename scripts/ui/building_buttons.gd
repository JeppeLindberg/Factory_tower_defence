extends HBoxContainer

var _buildings := preload("res://scripts/library/buildings.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var button_path: String

var _main_scene
var _building_placement


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_building_placement = get_node(_scene_paths.BUILDING_PLACEMENT)

	var buildings_dict = _buildings.get_all_buildings()
	for building_name in buildings_dict.keys():
		var new_button = _main_scene.create_node(button_path, self)
		new_button.building_name = building_name
		var sprite = load(buildings_dict[building_name]["sprite_path"])
		var texture = new_button.get_node("texture")
		texture.texture = sprite

# When one of the buttons have been pressed, pass it though here
func press_button(building_button):
	_building_placement.set_current_building(building_button.building_name)

