extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _terrain
var _paths


func _ready():
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")

# Can this placer recieve a resource?
func can_recieve_resource():
	var path = _paths.find_path_at_center_pos(global_position)

	if path == null:
		return false

	return path.check_can_recieve_at_pos(global_position)

# Recieve a resource
func receive_resource(resource):
	var path = _paths.find_path_at_center_pos(global_position)
	
	return path.receive_resource(resource, global_position)

