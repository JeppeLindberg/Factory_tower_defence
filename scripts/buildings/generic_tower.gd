extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()

@export var bullet_path: String

var _root_node
var _tower_specific
var _main_scene
var _world_timer
var _bullet_emitter
var _bullet_container
var _range_area2d
var _debug

var _next_shot_time
var _target


func activate():
	_root_node = get_parent()
	_tower_specific = get_child(0)
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_debug = get_node(_scene_paths.DEBUG)
	_bullet_emitter = _root_node.get_node("bullet_emitter")
	_bullet_container = _root_node.get_node("bullet_container")
	_range_area2d = _root_node.get_node("range")

	_next_shot_time = _world_timer.seconds() + _tower_specific.shots_per_second / 1.0

func _process(_delta):
	find_target()

	if _target == null and _world_timer.seconds() > _next_shot_time:
		# Make the next shot shoot immediately after a target is identified
		_next_shot_time = _world_timer.seconds()

	elif _target != null:
		# _debug.add_draw_line(_bullet_emitter.global_position, _target.global_position)

		if _world_timer.seconds() >= _next_shot_time:
			var charge_time = _world_timer.seconds() - _next_shot_time
			_next_shot_time += _tower_specific.shots_per_second / 1.0
			emit_bullet(charge_time)
	
# Find the enemy to shoot at. Currently just the closest.
func find_target():
	var enemy_areas = _range_area2d.get_overlapping_areas()
	for i in range(len(enemy_areas) -1, -1, -1):
		if not enemy_areas[i].get_parent().is_in_group(_groups.ENEMY):
			enemy_areas.remove_at(i)

	if len(enemy_areas) == 0:
		_target = null
		return

	var closest_enemy_area = enemy_areas[0]
	# Find the closest enemy area
	for i in range(1, len(enemy_areas)):
		if global_position.distance_to(enemy_areas[i].global_position) < \
			global_position.distance_to(closest_enemy_area.global_position):
			closest_enemy_area = enemy_areas[i]
	
	_target = closest_enemy_area.get_parent()

# Shoot a bullet, and charge it with time to move it forward in time corresponding to the difference between current time and next shot time.
func emit_bullet(charge_time):
	var new_bullet = _main_scene.create_node(bullet_path, _bullet_container)
	new_bullet.initialize(_bullet_emitter.global_position, _target, charge_time)
	
