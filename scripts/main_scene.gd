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

func quadrant_size():
	return Vector2(_map.cell_quadrant_size, _map.cell_quadrant_size)

func pos_to_cell_coord(pos):
	var quad_size = quadrant_size()

	return Vector2i(pos.x / quad_size.x, pos.y / quad_size.y)

func cell_coord_to_pos(coord):
	var quad_size = quadrant_size()

	return Vector2(coord.x * quad_size.x, coord.y * quad_size.y)

func create_node(prefab_path, parent):
	var scene = load(prefab_path)
	var new_node = scene.instantiate()
	parent.add_child(new_node)
	return new_node
