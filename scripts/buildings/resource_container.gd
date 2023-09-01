extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _root_node
var _terrain
var _paths

var _pickers = []
var _active_picker = 0

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
	if _pickers.is_empty():
		return

	var r = range(len(_pickers))
	for i in range(len(r)):
		r[i] -= _active_picker
		r[i] = r[i] % len(_pickers)

	for index in r:
		if get_children().is_empty():
			return
		
		var deposit_pos = _pickers[index].curve.get_point_position(0)

		if _pickers[index].check_can_recieve_at_pos(deposit_pos):
			_pickers[index].receive_resource(get_children()[0], deposit_pos)
			_active_picker -= 1
			_active_picker = _active_picker % len(_pickers)

# Set the path that picks from this container
func add_picker(picker):
	_pickers.append(picker)
