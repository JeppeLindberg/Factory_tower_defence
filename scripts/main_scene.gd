extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _debug
var _terrain
var _map

var _allow_activate_node = false

func _ready():
	_debug = get_node(_scene_paths.DEBUG)
	_terrain = get_node(_scene_paths.TERRAIN)
	_map = _terrain.get_node("map")

	randomize()

	_allow_activate_node = true

	activate_node(self)	

# Distributes a message to a node and its children recursively, that activates that node after all nodes have been instantiated
func activate_node(node):
	if not _allow_activate_node:
		return
	
	if node.has_method("activate"):
		node.activate()

	for child in node.get_children():
		activate_node(child)

# The number of seconds that has passed since scene start
func seconds():
	return float(Time.get_ticks_msec()) / 1000.0

# Return the size of each cell in relation to the in-engine coordinates
func quadrant_size():
	return Vector2(_map.cell_quadrant_size, _map.cell_quadrant_size)

# Transform an in-engine position to a location on the cell coordinates
func pos_to_coord(pos):
	var quad_size = quadrant_size()

	return Vector2i(pos.x / quad_size.x, pos.y / quad_size.y)

# Transform a location on the cell coordinates to an in-engine position
func coord_to_pos(coord):
	var quad_size = quadrant_size()

	return Vector2(coord.x * quad_size.x, coord.y * quad_size.y)

# Create an object in the world.
func create_node(prefab_path, parent):
	var scene = load(prefab_path)
	var new_node = scene.instantiate()
	parent.add_child(new_node)
	return new_node

# Return a random element from an array
func get_random_element(options):
	var index = randi() % options.size()
	return options[index]

var _result = []

# Get all children of the node that belongs to one or more of the the given groups
func get_children_in_groups(node, groups, recursive = false):
	_result = []

	if recursive:
		_get_children_in_groups_recursive(node, groups)
		return _result

	for child in node.get_children():
		for group in groups:				
			if child.is_in_group(group):
				_result.append(child)
				break

	return _result

# Get all children of the node that belongs to one or more of the the given groups
func _get_children_in_groups_recursive(node, groups):
	for child in node.get_children():
		for group in groups:				
			if child.is_in_group(group):
				_result.append(child)
				break
		_get_children_in_groups_recursive(child, groups)

# Get the footprint of a building, and account for the rotation of the building
func get_footprint(building_info, rotation_angle):
	var footprint_x = building_info["footprint_x"]
	var footprint_y = building_info["footprint_y"]

	if rotation_angle % 180 != 0:
		var temp = footprint_x
		footprint_x = footprint_y
		footprint_y = temp
	
	return Vector2i(footprint_x, footprint_y)

# Get the sprite transform for a building with the given footprint
func get_transform_from_footprint(footprint_x, footprint_y):
	var pos_x = 0
	var pos_y = 0
	var scale_x = 0.5
	var scale_y = 0.5

	if footprint_x == 1:
		pos_x = 16.0
	elif footprint_x == 2:
		pos_x = 32.0
	elif footprint_x == 3:
		pos_x = 48.0

	if footprint_y == 1:
		pos_y = 16.0
	elif footprint_y == 2:
		pos_y = 32.0
	elif footprint_y == 3:
		pos_y = 48.0

	return Transform2D(0, Vector2(scale_x, scale_y), 0, Vector2(pos_x, pos_y))	
