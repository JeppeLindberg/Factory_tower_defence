extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _controller_states := preload("res://scripts/library/controller_states.gd").new()

var _main_scene
var _building_placement
var _world_timer
var _tower_defence
var _debug

var _state = _controller_states.NONE
var _event_pos
var _tile_coord
var _all_buttons = []


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

		handle_place_building(event)
		handle_remove_tool(event)
		
	if event.is_action_pressed("start_round"):
		_tower_defence.start_round()
	
	if event.is_action_pressed("rotate"):
		_building_placement.rotate_placement()

		_building_placement.show_building_ghost_at(_tile_coord)
	
	if event.is_action_pressed("skip_to_next_wave"):
		_tower_defence.skip_to_next_wave()

# Check if placing a building is correct behavour, and then show ghost or place building.
func handle_place_building(event):
	if _state == _controller_states.PLACE_BUILDING and _building_placement.check_can_build():
		_building_placement.show_building_ghost_at(_tile_coord)
		
		if event is InputEventMouseButton and event.pressed:
			_building_placement.place_current_building_at_coord(_tile_coord)
	else:
		_building_placement.hide_building_ghost()
		return

# Handle all remove tool related events
func handle_remove_tool(event):
	pass

# Whenever a button is added, run this to add them to the set of all buttons.
func add_button(button):
	_all_buttons.append(button)
	button.set_selected(false)

# Called when a mouse event has been cought by a UI element
func hover_ui():
	_building_placement.hide_building_ghost()

# When a UI button is pressed/activated, the call is passed through here
func press_button(button):
	if button.button_type == "building":
		_building_placement.set_current_building(button.building_name)
		_state = _controller_states.PLACE_BUILDING
	
	if button.button_type == "tool":
		if button.tool_name == "remove":
			_state = _controller_states.REMOVE

	for b in _all_buttons:
		b.set_selected(b == button)


