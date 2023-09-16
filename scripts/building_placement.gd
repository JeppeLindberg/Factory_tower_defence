extends Node2D

var _buildings := preload("res://scripts/library/buildings.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _cell_states := preload("res://scripts/library/cell_states.gd").new()
var _tower_defence_states := preload("res://scripts/library/tower_defence_states.gd").new()

var _main_scene
var _tower_defence
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
	_tower_defence = get_node(_scene_paths.TOWER_DEFENCE)
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
	_building_ghost.visible = true

	var sprite = _building_ghost.get_node("sprite")
	var footprint = _main_scene.get_footprint(current_building, rotation_angle)

	_building_ghost.global_position = _main_scene.coord_to_pos(coord)

	_ghost_texture = load(current_building["sprite_path"])

	sprite.texture = _ghost_texture
	sprite.transform = _main_scene.get_transform_from_footprint(footprint.x, footprint.y)
	sprite.rotation_degrees = rotation_angle

# Hide the building ghost
func hide_building_ghost():
	_building_ghost.visible = false

# Place the current building at this coordinate
func place_current_building_at_coord(coord):
	var cell_coords = []
	var footprint = _main_scene.get_footprint(current_building, rotation_angle)

	for x in footprint.x:
		for y in footprint.y:
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

func check_can_build():
	if _tower_defence.get_state() == _tower_defence_states.PLANNING:
		return true
	return false

func rotate_placement():
	rotation_angle += 90

