extends Area2D

var _groups := preload("res://scripts/library/groups.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var speed: float
@export var damage: float

var _collider
var _debug

var _next_position
var _direction


func initialize(initial_pos, target_node, charge_time):
	_collider = get_node("collider")
	_debug = get_node(_scene_paths.DEBUG)
	global_position = initial_pos
	_next_position = initial_pos
	_direction = (target_node.global_position - global_position)
	_direction = _direction / _direction.length()
	_progress_time(charge_time)

func _process(delta):
	_progress_time(delta)

# Move the next_position along the path of the planned movement. Handle movement in the physics processor
func _progress_time(time):
	_next_position = _next_position + _direction * time * speed

# Move the bullet, and collide with enemies using a shapecast
func _physics_process(_delta):
	var space_state = get_world_2d().get_direct_space_state()
	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(_collider.shape)
	query.collide_with_areas = true
	query.transform = Transform2D(0, global_position)
	query.motion = _next_position - global_position
	query.collision_mask = 1
	_debug.add_draw_line(global_position, global_position+query.motion, Color.GREEN)
	
	global_position = _next_position

	var result = space_state.intersect_shape(query)
	if len(result) != 0:
		for res in result:
			var node = res.collider.get_parent()
			if node.is_in_group(_groups.ENEMY):
				collide_with_enemy(node)
				return

# Collide with an enemy, and handle all the following results
func collide_with_enemy(enemy_node):
	var enemy_generic = enemy_node.get_node("enemy_generic")
	enemy_generic.take_damage(damage)
	queue_free()

