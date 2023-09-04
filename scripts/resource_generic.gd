extends Node2D


func initialize(charge_time):
	_progress_time(charge_time)

func get_power():
	return {"kinetic": 1}

func get_state():
	pass

func _progress_time(charge_time):
	pass

