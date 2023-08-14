extends Node2D

var _cell_states := preload("res://scripts/library/cell_states.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _buildings
var _map: TileMap

var _cells_states


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_buildings = get_node("buildings")
	_map = get_node("map")

	_cells_states = []
	for cell_coord in _map.used_cell_coords:
		_cells_states.append([_cell_states.BUILDABLE])

# Get all relevant information about a given cell
func get_cell_state(coord):
	var index = find_index_of_cell(coord)
	return _cells_states[index]

# Finds the index, so that cells_states can be refered to by coordinates
func find_index_of_cell(coord):
	var index = _map.used_cell_coords.find(coord)
	return index

# Spawn a building at the given coordinate. the location has already been confirmed for being buildable
func spawn_building(building, coord):
	var new_building = _main_scene.create_node(building["prefab_path"], _buildings)
	new_building.global_position = _main_scene.cell_coord_to_pos(coord)

	for x in building["footprint_x"]:
		for y in building["footprint_y"]:
			var index = find_index_of_cell(Vector2i(coord.x + x, coord.y + y))
			_cells_states[index] = [_cell_states.OCCUPIED]

