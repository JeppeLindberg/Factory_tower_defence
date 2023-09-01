extends Node2D

var _buildings := preload("res://scripts/library/buildings.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _cell_states := preload("res://scripts/library/cell_states.gd").new()

var _main_scene
var _terrain
var _debug

var current_building = null
var current_building_name = null
var resources = 200
var rotation_angle = 0


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_debug = get_node(_scene_paths.DEBUG)
	set_current_building("drill_1")

func _process(_delta):
	_debug.add_debug_text("resources", resources)

# Change the currently active building
func set_current_building(building_name):
	current_building = _buildings.get_building_by_name(building_name)
	current_building_name = building_name

# Place the current building at this coordinate
func place_current_building_at_coord(coord):
	var cell_coords = []
	for x in range(current_building["footprint_x"]):
		for y in range(current_building["footprint_y"]):
			cell_coords.append(Vector2i(coord.x + x, coord.y + y))
	var cell_infos = []
	for cell_coord in cell_coords:
		cell_infos.append(_terrain.get_cell(cell_coord)["state"])

	for cell_info in cell_infos:
		if not _cell_states.BUILDABLE in cell_info:
			return

	if resources < current_building["cost"]:
		return
	
	_terrain.spawn_building(current_building_name, current_building, coord, rotation_angle)
	resources -= current_building["cost"]

func rotate_placement():
	rotation_angle += 90

