extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var new_path_path: String

var _main_scene
var _terrain
var _paths
var _debug

var path = null

func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")
	_debug = get_node(_scene_paths.DEBUG)

	var prev_coord = _main_scene.pos_to_cell_coord(global_position) + Vector2i.UP
	var this_coord = _main_scene.pos_to_cell_coord(global_position)
	var next_coord = _main_scene.pos_to_cell_coord(global_position) + Vector2i.DOWN

	connect_path(prev_coord, this_coord)
	connect_path(this_coord, next_coord)

func _process(_delta):
	if path != null:
		for i in range(path.curve.point_count - 1):
			_debug.add_draw_line(path.curve.get_point_position(i), path.curve.get_point_position(i+1), Color.AQUA)

# Connect the conveyor's path with new coordinates in the world
func connect_path(from_coord, to_coord):	
	var from_info = _terrain.get_cell(from_coord)

	if from_info["building"] == null:
		_start_new_path(from_coord, to_coord)	
	elif from_info["building"].building_name == "conveyor_belt" \
		and path == null:		
		var from_conveyor = from_info["building"].get_node("generic_building")
		path = from_conveyor.path
		_add_to_path(from_coord, to_coord)
	elif path != null:
		_add_to_path(from_coord, to_coord)

# Called when a new path is created, and instantiates it correctly
func _start_new_path(from_coord, to_coord):
	var from_pos = _main_scene.cell_coord_to_pos(from_coord) + _main_scene.quadrant_size() * 0.5
	var to_pos = _main_scene.cell_coord_to_pos(to_coord) + _main_scene.quadrant_size() * 0.5

	var new_path: Path2D = _main_scene.create_node(new_path_path, _paths)
	new_path.curve = Curve2D.new()
	new_path.curve.add_point(from_pos)
	new_path.curve.add_point(to_pos)

	path = new_path

# Add to an existing path
func _add_to_path(from_coord, to_coord):
	var from_pos = _main_scene.cell_coord_to_pos(from_coord) + _main_scene.quadrant_size() * 0.5
	var to_pos = _main_scene.cell_coord_to_pos(to_coord) + _main_scene.quadrant_size() * 0.5

	for i in range(path.curve.point_count - 1):
		if path.curve.get_point_position(i) == from_pos:
			if path.curve.get_point_position(i + 1) == to_pos:
				return

	path.curve.add_point(to_pos, Vector2(0, 0), Vector2(0, 0))
	return

