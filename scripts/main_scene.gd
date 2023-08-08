extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _debug
var _terrain
var _map


func _ready():
	_debug = get_node(_scene_paths.DEBUG)
	_terrain = get_node(_scene_paths.TERRAIN)
	_map = _terrain.get_node("map")

	_debug.show_grid = true

	randomize()

	activate_node(self)
	
func activate_node(node):
	if node.has_method("activate"):
		node.activate()

	for child in node.get_children():
		activate_node(child)

# Return the size of each cell in relation to the in-engine coordinates
func quadrant_size():
	return Vector2(_map.cell_quadrant_size, _map.cell_quadrant_size)

# Transform an in-engine position to a location on the cell coordinates
func pos_to_cell_coord(pos):
	var quad_size = quadrant_size()

	return Vector2i(pos.x / quad_size.x, pos.y / quad_size.y)

# Transform a location on the cell coordinates to an in-engine position
func cell_coord_to_pos(coord):
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
