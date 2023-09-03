extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()

var _terrain
var _paths


func _ready():
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")

# Can this placer recieve a resource?
func can_recieve_resource():
	var container = _paths.find_transport_node_at_pos(global_position, [_groups.CONTAINER])

	if container == null:
		return false

	return container.container.can_recieve_resource()

# Recieve a resource
func receive_resource(resource):
	var container = _paths.find_transport_node_at_pos(global_position, [_groups.CONTAINER])
	
	return container.container.receive_resource(resource)


