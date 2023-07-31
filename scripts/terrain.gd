extends Node2D

var _cell_states := preload("res://scripts/library/cell_states.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _buildings


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_buildings = get_node("buildings")

# Get all relevant information about a given cell
func get_cell_state(coord):
	var ret_state = []

	for child in _buildings.get_children():
		if _main_scene.pos_to_cell_coord(child.global_position) == coord:
			ret_state.append(_cell_states.OCCUPIED)
			break

	if not _cell_states.OCCUPIED in ret_state:
		ret_state.append(_cell_states.BUILDABLE)

	return ret_state

# Spawn a building at the given coordinate. the location has already been confirmed for being buildable
func spawn_building(prefab_path, coord):
	var new_building = _main_scene.create_node(prefab_path, _buildings)
	new_building.global_position = _main_scene.cell_coord_to_pos(coord)

