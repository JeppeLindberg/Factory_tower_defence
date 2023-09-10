extends Node2D

var _buildings := preload("res://scripts/library/buildings.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _cell_states := preload("res://scripts/library/cell_states.gd").new()

var _main_scene
var _terrain
var _debug
var _building_ghost

var current_building = null
var current_building_name = null
var resources = 200
var rotation_angle = 0

var _ghost_texture


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_debug = get_node(_scene_paths.DEBUG)
	_building_ghost = get_node("building_ghost")

	set_current_building("stone_drill")

func _process(_delta):
	_debug.add_debug_text("resources", resources)

# Change the currently active building
func set_current_building(building_name):
	current_building = _buildings.get_building_by_name(building_name)
	current_building_name = building_name

# Show the ghost at the given coordinate, with the current placement rotation
func show_building_ghost_at(coord):
	var sprite = _building_ghost.get_node("sprite")

	_building_ghost.global_position = _main_scene.coord_to_pos(coord)

	_ghost_texture = load(current_building["sprite_path"])

	sprite.texture = _ghost_texture
	sprite.transform = _get_transform_from_footprint(current_building["footprint_x"], current_building["footprint_y"])
	sprite.rotation_degrees = rotation_angle

# Get the sprite transform for a building with the given footprint
func _get_transform_from_footprint(footprint_x, footprint_y):
	var pos_x = 0
	var pos_y = 0
	var scale_x = 0.5
	var scale_y = 0.5

	if footprint_x == 1:
		pos_x = 16.0
	elif footprint_x == 2:
		pos_x = 32.0

	if footprint_y == 1:
		pos_y = 16.0
	elif footprint_y == 2:
		pos_y = 32.0

	return Transform2D(0, Vector2(scale_x, scale_y), 0, Vector2(pos_x, pos_y))	

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

