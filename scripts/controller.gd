extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _building_placement
var _world_timer
var _tower_defence
var _debug

var _event_pos
var _tile_coord

# Called when the node enters the scene tree for the first time.
func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_building_placement = get_node(_scene_paths.BUILDING_PLACEMENT)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_tower_defence = get_node(_scene_paths.TOWER_DEFENCE)
	_debug = get_node(_scene_paths.DEBUG)

# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	if event is InputEventMouse:
		var footprint = _main_scene.get_footprint(_building_placement.current_building, _building_placement.rotation_angle)

		_event_pos = event.position
		_event_pos -= Vector2((footprint.x - 1) * (_main_scene.quadrant_size().x / 2),
								(footprint.y - 1) * (_main_scene.quadrant_size().y / 2))

		_tile_coord = _main_scene.pos_to_coord(_event_pos)

		_debug.add_debug_text("placement position", str(_tile_coord))

		_building_placement.show_building_ghost_at(_tile_coord)
		
		if event is InputEventMouseButton and event.pressed:
			_building_placement.place_current_building_at_coord(_tile_coord)
	
	if event.is_action_pressed("start_round"):
		_tower_defence.start_round()
	
	if event.is_action_pressed("rotate"):
		_building_placement.rotate_placement()

		_building_placement.show_building_ghost_at(_tile_coord)
	
	if event.is_action_pressed("skip_to_next_wave"):
		_tower_defence.skip_to_next_wave()
