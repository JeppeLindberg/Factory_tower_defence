extends Node2D

var _timer_states := preload("res://scripts/library/timer_states.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _debug

var time_mult = 1.0
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

# Start execution of game
func play():
	if _state == _timer_states.PAUSED:
		_state = _timer_states.PLAYING
		time_mult = 1.0

# Pause the execution of the game
func pause():
	if _state == _timer_states.PLAYING:
		_state = _timer_states.PAUSED
		time_mult = 0.0

# Pause/unpause the world
func toggle_pause():
	if _state == _timer_states.PLAYING:
		_state = _timer_states.PAUSED
		time_mult = 0.0
	elif _state == _timer_states.PAUSED:
		_state = _timer_states.PLAYING
		time_mult = 1.0

# Stop the timer. It cannot be un-stopped
func stop():
	_state = _timer_states.STOPPED

# Return the amount of seconds (floating point) that has elapsed in the world timer
func seconds():
	return _seconds


