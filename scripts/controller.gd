extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _building_placement
var _world_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_building_placement = get_node(_scene_paths.BUILDING_PLACEMENT)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)

# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var tile_pos = _main_scene.pos_to_cell_coord(event.position)
		
		_building_placement.place_current_building_at_coord(tile_pos)
	
	if event.is_action_pressed("pause_play"):
		_world_timer.toggle_pause()
