extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _root_node
var _terrain
var _paths

var _pickers = []

func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_root_node = get_parent()
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")

	for x in range(_root_node.footprint.x):
		for y in range(_root_node.footprint.y):
			var offset = Vector2i(x, y)
			_paths.create_container(_main_scene.pos_to_cell_coord(_root_node.global_position) + offset, self)

func _process(_delta):
	for path in _pickers:
		if get_children().is_empty():
			return
		
		var deposit_pos = path.curve.get_point_position(0)

		if path.check_can_recieve_at_pos(deposit_pos):
			path.receive_resource(get_children()[0], deposit_pos)

# Set the path that picks from this container
func add_picker(picker):
	_pickers.append(picker)
