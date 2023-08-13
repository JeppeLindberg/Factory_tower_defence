extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()

var _root_node
var _enemy_specific
var _main_scene
var _world_timer
var _tower_defence
var _terrain
var _behaviour_nodes
var _spawn_node
var _target_node
var _health_bar
var _health_scalar

var _max_health = 3
var _health = 3
var _spawn_time

func activate():
	_root_node = get_parent()
	_enemy_specific = get_child(0)
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_tower_defence = get_node(_scene_paths.TOWER_DEFENCE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_behaviour_nodes = _terrain.get_node("behaviour_nodes")
	_health_bar = _root_node.get_node("health_bar")
	_health_scalar = _health_bar.get_node("scalar")

	_root_node.add_to_group(_groups.ENEMY)
	
	_find_spawner_and_target()

	_spawn_time = _world_timer.seconds()
	_root_node.global_position = _spawn_node.global_position

# Finds the spawner and target that this enemy uses
func _find_spawner_and_target():
	var all_behaviour_nodes = _behaviour_nodes.get_children()
	var all_spawners = []
	var all_targets = []

	for node in all_behaviour_nodes:
		if node.is_in_group(_groups.ENEMY_SPAWNER):
			all_spawners.append(node)
		elif node.is_in_group(_groups.ENEMY_TARGET):
			all_targets.append(node)
	
	_spawn_node = _main_scene.get_random_element(all_spawners)
	_target_node = _main_scene.get_random_element(all_targets)

func _process(_delta):
	var time_elapsed = _world_timer.seconds() - _spawn_time
	var weight = time_elapsed * _enemy_specific.speed / 10.0
	_root_node.global_position = lerp(_spawn_node.global_position, _target_node.global_position, weight)

	if weight > 1:
		_tower_defence.take_damage()
		die()

# Take damage from a tower's bullet
func take_damage(damage):
	_health -= damage

	_health_bar.visible = _health != _max_health
	_health_scalar.scale = Vector2(_health/_max_health, 1)

	if _health <= 0:
		die()

func die():
	_root_node.queue_free()

