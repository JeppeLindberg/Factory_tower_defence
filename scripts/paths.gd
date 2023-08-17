extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var new_path_path: String

var _main_scene
var _terrain
var _debug

func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_debug = get_node(_scene_paths.DEBUG)

func _process(_delta):
	var child_index = 0
	var offset_vector = Vector2.ONE
	
	for path in get_children():
		for i in range(path.curve.point_count - 1):
			_debug.add_draw_line(path.curve.get_point_position(i) + offset_vector * child_index, 
				path.curve.get_point_position(i+1) + offset_vector * child_index,
				lerp(Color.AQUA, Color.BLACK, float(i) / float(path.curve.point_count - 1)))
		child_index += 1

# Connect two coordinates with paths. Adapts to whatever situation is happening at the coordinates
func connect_coords(from_coord, to_coord):
	var merge_paths = _find_merge_paths(from_coord, to_coord)

	if merge_paths:
		_merge_paths(merge_paths[0], merge_paths[1])
		return
	
	var append_path = _find_append_path(from_coord)

	if append_path:
		_append_to_path(append_path, to_coord)
		return

	var from_info = _terrain.get_cell(from_coord)

	if from_info["building"] == null:
		_start_new_path(from_coord, to_coord)

# Find a path that can be appended to from the current coordinate
func _find_append_path(last_coord):
	var last_pos = _coord_to_center_pos(last_coord)

	for path in get_children():
		var last_point_index = path.curve.point_count - 1
		if path.curve.get_point_position(last_point_index) == last_pos:
			return path
	
	return null

# Find paths that can be merged with the coming coordinates
func _find_merge_paths(from_coord, to_coord):
	var from_pos = _coord_to_center_pos(from_coord)
	var to_pos = _coord_to_center_pos(to_coord)

	var path_from_match_end = null
	for path in get_children():
		var last_point_index = path.curve.point_count - 1
		if path.curve.get_point_position(last_point_index) == from_pos:
			path_from_match_end = path
	
	if !path_from_match_end:
		return null
	
	var path_to_match_begin = null
	for path in get_children():
		if path.curve.get_point_position(0) == to_pos:
			path_to_match_begin = path

	if !path_to_match_begin:
		return null
	
	return [path_from_match_end, path_to_match_begin]

# Add to an existing path
func _append_to_path(path, to_coord):
	var to_pos = _coord_to_center_pos(to_coord)

	path.curve.add_point(to_pos)

# Add path_b curve to path_a, and delete path_b
func _merge_paths(path_a, path_b):
	for i in range(path_b.curve.point_count):
		path_a.curve.add_point(path_b.curve.get_point_position(i))
	
	path_b.queue_free()

# Called when a new path is created, and instantiates it correctly
func _start_new_path(from_coord, to_coord):
	var from_pos = _coord_to_center_pos(from_coord)
	var to_pos = _coord_to_center_pos(to_coord)

	var new_path: Path2D = _main_scene.create_node(new_path_path, self)
	new_path.curve = Curve2D.new()
	new_path.curve.add_point(from_pos)
	new_path.curve.add_point(to_pos)

# Find the position of the center of a cell based on its coordinates
func _coord_to_center_pos(coord):
	var pos = _main_scene.cell_coord_to_pos(coord) + _main_scene.quadrant_size() * 0.5
	return pos