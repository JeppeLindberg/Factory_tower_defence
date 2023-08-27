extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()

@export var new_path_path: String
@export var container_path: String
@export var conveyor_path: String

var _main_scene
var _terrain
var _debug

func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_debug = get_node(_scene_paths.DEBUG)

# Debug reasons
func _process(_delta):
	var child_index = 0
	var offset_vector = Vector2.ONE

	for path in _main_scene.get_children_in_group(self, _groups.PATH):
		for i in range(path.curve.point_count - 1):
			_debug.add_draw_line(path.curve.get_point_position(i) + offset_vector * child_index, 
				path.curve.get_point_position(i+1) + offset_vector * child_index,
				lerp(Color.AQUA, Color.BLACK, float(i) / float(path.curve.point_count - 1)))
		child_index += 1
	
	for container in _main_scene.get_children_in_group(self, _groups.CONTAINER):
		_debug.add_draw_line(container.global_position + Vector2.UP * 5, 
							container.global_position + Vector2.LEFT * 5, 
							Color.GREEN)
		_debug.add_draw_line(container.global_position + Vector2.LEFT * 5, 
							container.global_position + Vector2.DOWN * 5, 
							Color.GREEN)
		_debug.add_draw_line(container.global_position + Vector2.DOWN * 5, 
							container.global_position + Vector2.RIGHT * 5, 
							Color.GREEN)
		_debug.add_draw_line(container.global_position + Vector2.RIGHT * 5, 
							container.global_position + Vector2.UP * 5, 
							Color.GREEN)

# Create a node that describes a spot where resources can be deposited or retrieved
func create_container(coord, container):
	var new_container = _main_scene.create_node(container_path, self)
	new_container.add_to_group(_groups.CONTAINER)
	new_container.global_position = _coord_to_center_pos(coord)
	new_container.container = container

# Create a node that can transport resources between buildings
func create_conveyor(coord, conveyor):
	var new_conveyor = _main_scene.create_node(conveyor_path, self)
	new_conveyor.add_to_group(_groups.CONVEYOR)
	new_conveyor.global_position = _coord_to_center_pos(coord)
	new_conveyor.conveyor = conveyor

# Connect two coordinates with paths. Adapts to whatever situation is happening at the coordinates
func connect_coords(from_coord, to_coord):
	var from_node = _find_transport_node(from_coord)
	var to_node = _find_transport_node(to_coord)

	if from_node == null or \
		to_node == null:
		return

	var new_path = _create_path(from_coord, to_coord)

	if from_node.is_in_group(_groups.CONTAINER):
		from_node.container.add_picker(new_path)
		new_path.container = from_node.container

	_merge_all_paths()

# Merge all paths in the system
func _merge_all_paths():
	var repeat = true

	while repeat:
		repeat = false

		for path_end in _main_scene.get_children_in_group(self, _groups.PATH):
			if repeat:
				break

			for path_begin in _main_scene.get_children_in_group(self, _groups.PATH):
				if repeat:
					break

				var end_index = path_end.curve.point_count - 1
				var begin_index = 0

				if path_end.curve.get_point_position(end_index) == path_begin.curve.get_point_position(begin_index):
					_merge_paths(path_end, path_begin)
					repeat = true

# Add path_b curve to path_a, and delete path_b
func _merge_paths(path_a, path_b):
	for i in range(path_b.curve.point_count):
		path_a.curve.add_point(path_b.curve.get_point_position(i))
	
	if path_b.container:
		path_b.container.add_picker(path_a)

	path_b.queue_free()

# Called when a new path is created, and instantiates it correctly
func _create_path(from_coord, to_coord):
	var from_pos = _coord_to_center_pos(from_coord)
	var to_pos = _coord_to_center_pos(to_coord)

	var new_path: Path2D = _main_scene.create_node(new_path_path, self)
	new_path.add_to_group(_groups.PATH)
	new_path.curve = Curve2D.new()
	new_path.curve.add_point(from_pos)
	new_path.curve.add_point(to_pos)

	return new_path

# Find the position of the center of a cell based on its coordinates
func _coord_to_center_pos(coord):
	var pos = _main_scene.cell_coord_to_pos(coord) + _main_scene.quadrant_size() * 0.5
	return pos

# Finds a transport node (container/conveyor) on the given position
func _find_transport_node(coord):
	var pos = _coord_to_center_pos(coord)
	for child in get_children():
		if child.global_position == pos:
			return child
	
	return null
