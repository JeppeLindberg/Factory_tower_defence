extends Node2D

var _cell_states := preload("res://scripts/library/cell_states.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _buildings
var _map: TileMap

var _cells


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_buildings = get_node("buildings")
	_map = get_node("map")

	_cells = []
	for cell_coord in _map.used_cell_coords:
		_cells.append({"building": null, "state": [_cell_states.BUILDABLE]})

# Get all relevant information about a given cell
func get_cell(coord):
	var index = find_index_of_cell(coord)
	return _cells[index]

# Finds the index, so that cells_states can be refered to by coordinates
func find_index_of_cell(coord):
	var index = _map.used_cell_coords.find(coord)
	return index

# Spawn a building at the given coordinate. the location has already been confirmed for being buildable
func spawn_building(building_name, building_info, coord, rotation_angle):
	var new_building = _main_scene.create_node(building_info["prefab_path"], _buildings)
	var footprint = _main_scene.get_footprint(building_info, rotation_angle)

	new_building.building_name = building_name
	new_building.footprint = footprint
	new_building.cost = building_info["cost"]

	for x in footprint.x:
		for y in footprint.y:
			var index = find_index_of_cell(Vector2i(coord.x + x, coord.y + y))
			_cells[index]["building"] = new_building
			_cells[index]["state"] = [_cell_states.OCCUPIED]
	
	new_building.initialize(_main_scene.coord_to_pos(coord), rotation_angle)

func remove_building(building):
	var footprint = building.footprint
	var building_coord = _main_scene.pos_to_coord(building.global_position)

	building.destroy()

	for x in footprint.x:
		for y in footprint.y:
			var this_coord = Vector2i(building_coord.x + x, building_coord.y + y)
			var index = find_index_of_cell(this_coord)
			_cells[index] = {"building": null, "state": [_cell_states.BUILDABLE]}
