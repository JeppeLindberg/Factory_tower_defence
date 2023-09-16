extends Path2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var path_follow_path: String

var _main_scene
var _world_timer

# TODO: Remove these two variables for stability
var container
var placer
var _resource_node_radius = 0.2 # Scaled with the size of tiles
var _path_move_speed = 2.0 # Tiles per second


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)

	var scalar = (_main_scene.quadrant_size().x + _main_scene.quadrant_size().y) / 2
	_resource_node_radius = _resource_node_radius * scalar
	_path_move_speed = _path_move_speed * scalar

# Move all child path_follow nodes along the path
func _process(delta):
	var world_delta = delta * _world_timer.time_mult

	for path_follow in get_children():
		var next_progress = path_follow.progress + world_delta * _path_move_speed
		var next_possible_progress = _get_next_unoccupied_progress(path_follow.progress + _resource_node_radius) - _resource_node_radius
		var path_end = _path_len()
		next_possible_progress = min(path_end - _resource_node_radius/2, next_possible_progress)
			
		if next_progress > next_possible_progress:
			next_progress = next_possible_progress

		path_follow.progress = next_progress

		if placer != null and \
				path_follow.progress >= path_end - _resource_node_radius and \
				placer.can_recieve_resource():
			placer.receive_resource(path_follow.get_child(0))
			path_follow.queue_free()

# Recieve a resource so that it can be moved along the path
func receive_resource(resource, pos = null):
	if pos == null:
		pos = curve.get_point_position(0)

	var path_follow = _main_scene.create_node(path_follow_path, self)
	path_follow.global_position = pos
	resource.reparent(path_follow)
	resource.global_position = pos
	path_follow.progress = _pos_to_progress(pos)

# Check if the path can recieve a resouce at the start position of the path
func check_can_recieve():
	var pos = curve.get_point_position(0)
	return check_can_recieve_at_pos(pos)

# Check if the given position is occupied or otherwise unavailable
func check_can_recieve_at_pos(pos):
	var progress = _pos_to_progress(pos)
	var closest_progress = 10000.0

	for path_follow in get_children():
		if abs(path_follow.progress - progress) < closest_progress:
			closest_progress = abs(path_follow.progress - progress)

	if closest_progress < _resource_node_radius * 2:
		return false

	return true

# Sets the placer for placing items on at the end of the path
func set_placer(new_placer):
	placer = new_placer

# Finds the point on the curve that is closest to "pos", and translates that to a "progress" property
func _pos_to_progress(pos):
	return curve.get_closest_offset(pos)

# Get the position that is unoccupied from the position from_prog. Given in "progress" path_follow property
func _get_next_unoccupied_progress(from_prog):
	var next_occupied_progress = 10000.0

	for path_follow in get_children():
		if from_prog <= path_follow.progress:
			if path_follow.progress < next_occupied_progress:
				next_occupied_progress = path_follow.progress

	if next_occupied_progress != 10000.0:
		return next_occupied_progress - _resource_node_radius

	return 10000.0

# Get the total length of the curve
func _path_len():
	var total_len = 0.0

	for i in range(curve.point_count - 1):
		total_len += curve.get_point_position(i).distance_to(curve.get_point_position(i+1))
	
	return total_len


