extends Node2D


func _get_upgrades_with_method(method_name):
	var ret = []
	for child in get_children():
		if child.has_method(method_name):
			ret.append(child)
	return ret;

func get_power(resource):
	var power = resource.get_power()

	for upgrade in _get_upgrades_with_method('modify_power'):
		power = upgrade.modify_power(power)

	return power
