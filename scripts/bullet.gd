extends Area2D

var _groups := preload("res://scripts/library/groups.gd").new()

@export var speed: float
@export var damage: float

var _direction


func initialize(initial_pos, target_node, charge_time):
	global_position = initial_pos
	_direction = (target_node.global_position - global_position)
	_direction = _direction / _direction.length()
	_progress_time(charge_time)

func _process(delta):
	_progress_time(delta)

func _progress_time(time):
	var next_pos = global_position + _direction * time * speed
	var cast = ShapeCast2D.new()

func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group(_groups.ENEMY):
		print("enemy_hit")
