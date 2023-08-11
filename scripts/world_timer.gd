extends Node2D

var _timer_states := preload("res://scripts/library/timer_states.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _debug

var _seconds = 0
var _state 


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_debug = get_node(_scene_paths.DEBUG)
	_state = _timer_states.PLAYING

func _process(delta):
	_debug.add_debug_text("world_timer state", _state)
	if _state == _timer_states.PLAYING:
		_seconds += delta

# Pause/unpause the world
func toggle_pause():
	if _state == _timer_states.PLAYING:
		_state = _timer_states.PAUSED
	elif _state == _timer_states.PAUSED:
		_state = _timer_states.PLAYING

# Stop the timer. It cannot be un-stopped
func stop():
	_state = _timer_states.STOPPED

# Return the amount of seconds (floating point) that has elapsed in the world timer
func seconds():
	return _seconds


