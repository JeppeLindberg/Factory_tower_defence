extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()

var resource_container # The container that contains the shootable resources
var bullet_container # The node that contains all bullets that this tower has shot
var bullet_emitter # The node that emits bullets for this tower (centered on the building)
var generic_building

var _tower_specific
var _main_scene
var _world_timer
var _range_area2d
var _debug

var _next_shot_time
var _target


func activate():
	generic_building = get_parent()
	_tower_specific = get_child(0)
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_debug = get_node(_scene_paths.DEBUG)
	bullet_emitter = generic_building.get_node("bullet_emitter")
	bullet_container = generic_building.get_node("bullet_container")
	resource_container = generic_building.get_node("resource_container")
	_range_area2d = generic_building.get_node("range")

	_next_shot_time = _world_timer.seconds() + 1.0 / _tower_specific.shots_per_second
	_range_area2d.get_node("collision").shape.radius = _tower_specific.get_range_as_pixels()

func _process(_delta):
	find_target()

	if (not can_shoot()) and _world_timer.seconds() > _next_shot_time:
		# Make the next shot shoot immediately after a target is identified
		_next_shot_time = _world_timer.seconds()

	elif can_shoot():
		_debug.add_draw_line(bullet_emitter.global_position, _target.global_position, Color.DARK_RED)
		
		if _world_timer.seconds() >= _next_shot_time:
			var charge_time = _world_timer.seconds() - _next_shot_time
			_next_shot_time += 1.0 / _tower_specific.shots_per_second
			shoot(charge_time)
	
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

# Check wether this tower can currently shoot
func can_shoot():
	if _target == null:
		return false

	if len(resource_container.get_children()) == 0:
		return false

	return true

# Shoot a bullet, and charge it with time to move it forward in time corresponding to the difference between current time and next shot time.
# The specific tower implementation handles the specifics of the shooting
func shoot(charge_time):
	_tower_specific.shoot(_target, charge_time)
	

