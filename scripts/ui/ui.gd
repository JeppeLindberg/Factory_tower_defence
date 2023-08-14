extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene

var _screen_size
var _screen_pos
var _bottom_center


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_bottom_center = get_node("bottom_center")

# Handle all kinds of resizing/moving of the visible rectangle
func _process(_delta):
	_screen_size = get_viewport().get_visible_rect().size
	_screen_pos = get_viewport().get_visible_rect().position

	_bottom_center.global_position = _screen_pos + Vector2(_screen_size.x * 0.5, _screen_size.y)


