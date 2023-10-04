extends Node2D

var _power_types := preload("res://scripts/library/power_types.gd").new()

@export var kinetic_dmg_mult: float


func modify_power(power):
	power[_power_types.KINETIC] = power[_power_types.KINETIC] * kinetic_dmg_mult
	return power
