extends Node2D

@export var kinetic_power: float

func get_power():
	return {"kinetic": kinetic_power}
