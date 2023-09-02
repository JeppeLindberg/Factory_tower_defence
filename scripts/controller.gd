extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _building_placement
var _world_timer
var _debug


# Called when the node enters the scene tree for the first time.
func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_building_placement = get_node(_scene_paths.BUILDING_PLACEMENT)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_debug = get_node(_scene_paths.DEBUG)

# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	if event is InputEventMouse:
		var event_coord = _main_scene.pos_to_coord(event.position)
		_debug.add_debug_text("cursor position", str(event_coord))		

	if event is InputEventMouseButton and event.pressed:
		var footprint_x = _building_placement.current_building["footprint_x"]
		var footprint_y = _building_placement.current_building["footprint_y"]
		var event_pos = event.position
		event_pos -= Vector2((footprint_x - 1) * (_main_scene.quadrant_size().x / 2),
								(footprint_y - 1) * (_main_scene.quadrant_size().y / 2))

		var tile_pos = _main_scene.pos_to_coord(event_pos)
		
		_building_placement.place_current_building_at_coord(tile_pos)
	
	if event.is_action_pressed("pause_play"):
		_world_timer.toggle_pause()
	
	if event.is_action_pressed("rotate"):
		_building_placement.rotate_placement()
