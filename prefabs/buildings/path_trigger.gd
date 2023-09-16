extends Node2D

var _groups := preload("res://scripts/library/groups.gd").new()

var _parent


func _ready():
	add_to_group(_groups.PATH_TRIGGER)
	_parent = get_parent()

func create_transport_nodes():
	_parent.create_transport_nodes()

func transport_nodes_deleted():
	if _parent.has_method("transport_nodes_deleted"):
		_parent.transport_nodes_deleted()
	