extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _tower_defence_states := preload("res://scripts/library/tower_defence_states.gd").new()

var _main_scene
var _world_timer
var _debug
var _terrain
var _enemies

@export var enemy_path: String

var _state
var _next_event_timer
var _remaining_health = 10
var _remaining_enemy_spawns


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_debug = get_node(_scene_paths.DEBUG)
	_terrain = get_node(_scene_paths.TERRAIN)
	_enemies = _terrain.get_node("enemies")

	_next_event_timer = _world_timer.seconds() + 30

	_state = _tower_defence_states.WAITING_FOR_NEXT_WAVE

func _process(_delta):
	_debug.add_debug_text("tower_defence state", _state)
	_debug.add_debug_text("health", _remaining_health)

	while _world_timer.seconds() > _next_event_timer:
		if _state == _tower_defence_states.WAITING_FOR_NEXT_WAVE:
			_remaining_enemy_spawns = 10
			change_state(_tower_defence_states.ONGOING_WAVE)

		if _state == _tower_defence_states.ONGOING_WAVE:
			spawn_enemy()
			if _remaining_enemy_spawns <= 0:
				_next_event_timer += 10.0
				change_state(_tower_defence_states.WAITING_FOR_NEXT_WAVE)
			else:
				_next_event_timer += 0.1

# Change the state of the tower defence part of the game
func change_state(new_state):
	_state = new_state

# Spawn an enemy. Each enemy spawn behavour is handled by the enemy itself.
func spawn_enemy():
	_remaining_enemy_spawns -= 1
	_main_scene.create_node(enemy_path, _enemies)

# Take damage from an enemy reaching the reactor
func take_damage():
	_remaining_health -= 1
	if _remaining_health == 0:
		_world_timer.stop()


