extends Node2D

var _resource_specific

func initialize(charge_time):
	_resource_specific = get_child(0)

	_progress_time(charge_time)

func get_power():
	return _resource_specific.get_power()

func get_state():
	pass

func _progress_time(charge_time):
	pass

