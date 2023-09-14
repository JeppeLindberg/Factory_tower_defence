extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _sprite
var generic_building

var building_name
var footprint

func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_sprite = get_node("sprite")
	generic_building = get_node("generic_building")

func initialize(global_pos, rotation_angle):
	global_position = global_pos
	_sprite.transform = _main_scene.get_transform_from_footprint(footprint.x, footprint.y)
	_sprite.rotation_degrees = rotation_angle
	_main_scene.activate_node(self)

# Get the rotation of the building, which is only applied to the sprite by default
func get_building_rotation():
	return _sprite.rotation_degrees

# Remove this building from the terrain
func destroy():
	generic_building.destroy()

