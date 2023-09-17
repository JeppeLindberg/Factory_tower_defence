extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _power_types := preload("res://scripts/library/power_types.gd").new()

@export var footprint: Vector2i
@export var shots_per_second = 1.0
@export var targeting_range: float # number of squares

@export var bullet_path: String
@export var kinetic_power_mult: float
@export var bullet_split: int
@export var accuracy: float # max degrees of spread

var _tower_generic
var _main_scene


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_tower_generic = get_parent()

func _process(_delta):
	if _tower_generic.target != null:
		var look_direction = _tower_generic.bullet_emitter.global_position - _tower_generic.target.global_position
		var angle = look_direction.angle()
		_tower_generic.bullet_emitter.rotation = angle

# Shoot a bullet, and charge it with time to move it forward in time corresponding to the difference between current time and next shot time.
func shoot(target, charge_time):
	var start_pos = _tower_generic.bullet_emitter.global_position
	var move_range = get_range_as_pixels() * 1.25
	var resource = _tower_generic.resource_container.select_pick_resource()
	var damage = _get_damage(resource.get_power())

	for i in range(bullet_split):
		var new_bullet = _main_scene.create_node(bullet_path, _tower_generic.bullet_container)
		var direction = (target.global_position - _tower_generic.bullet_emitter.global_position)
		var diversion_angle = randf_range(0, accuracy * 2) - accuracy

		direction = direction.rotated(deg_to_rad(diversion_angle))
		new_bullet.initialize(start_pos, direction, charge_time, move_range, damage)
	
	resource.queue_free()

# Convert from number of cells to pixels
func get_range_as_pixels():
	var quadrant_size = _main_scene.quadrant_size()
	return targeting_range * (quadrant_size.x + quadrant_size.y) / 2

# Transforms the power stats of a resource into the damage of a bullet
func _get_damage(power):
	var result = 0

	for key in power:
		if key == _power_types.KINETIC:
			result += power[key] * kinetic_power_mult
	
	return result

