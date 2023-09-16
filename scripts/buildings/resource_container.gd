extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var resource_capacity = -1

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
			_paths.create_container(_main_scene.pos_to_coord(_root_node.global_position) + offset, self)
	
	_paths.autoconnect_all()

func _process(_delta):
	if _pickers.is_empty():
		return

	var queue = _get_picker_queue()

	for index in queue:
		if get_children().is_empty():
			return
		
		var resource = select_pick_resource()
		try_pick_resource(resource, index)

# Get the order of checking which picker should recieve a resource
func _get_picker_queue():	
	var queue = range(len(_pickers))
	for i in range(len(queue)):
		queue[i] -= _active_picker
		queue[i] = queue[i] % len(_pickers)
	return queue

# Set the path that picks from this container
func add_picker(picker):
	_pickers.append(picker)

# Check wether the container can recieve a resource
func can_recieve_resource():
	if resource_capacity == 0:
		for path in _pickers:
			if path.check_can_recieve():
				return true
		
		return false

	return true

# Put a given resource into the container
func receive_resource(resource):
	resource.reparent(self)
	resource.position = Vector2.ZERO

	if resource_capacity == 0:		
		var queue = _get_picker_queue()

		for index in queue:
			if try_pick_resource(resource, index):
				break

# Attempt to move the given resource to a picker
func try_pick_resource(resource, picker_index):
	if _pickers[picker_index].check_can_recieve():
		_pickers[picker_index].receive_resource(resource)
		_active_picker -= 1
		_active_picker = _active_picker % len(_pickers)
		return true

	return false

# Pick a resource out if the container that matches at least one group
func select_pick_resource(groups = []):
	var children = null

	if groups == []:
		children = get_children()
	else:
		children = _main_scene.get_children_in_groups(self, groups)

	return children[0]
