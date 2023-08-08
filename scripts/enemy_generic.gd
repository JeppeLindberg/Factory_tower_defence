extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()

var _root_node
var _enemy_specific
var _main_scene
var _terrain
var _behaviour_nodes
var _spawn_node
var _target_node


func activate():
	_root_node = get_parent()
	_enemy_specific = get_child(0)
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_behaviour_nodes = _terrain.get_node("behaviour_nodes")
	
	_find_spawner_and_target()

	global_position = _spawn_node.global_position

# Finds the spawner and target that this enemy uses
func _find_spawner_and_target():
	var all_behaviour_nodes = _behaviour_nodes.get_children
	var all_spawners = []
	var all_targets = []

	for node in all_behaviour_nodes:
		if node.is_in_group(_groups.ENEMY_SPAWNER):
			all_spawners.append(node)
		elif node.is_in_group(_groups.ENEMY_TARGET):
			all_targets.append(node)
	
	_spawn_node = _main_scene.get_random_element(all_spawners)
	_target_node = _main_scene.get_random_element(all_targets)

