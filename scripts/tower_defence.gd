extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()
var _tower_defence_states := preload("res://scripts/library/tower_defence_states.gd").new()

var _main_scene
var _world_timer
var _debug
var _terrain
var _enemies
var _paths

@export var enemy_path: String

var _state
var _next_event_timer
var _remaining_health = 10
var _remaining_enemy_spawns
var _remaining_enemies = 0


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_debug = get_node(_scene_paths.DEBUG)
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")
	_enemies = _terrain.get_node("enemies")

	_state = _tower_defence_states.PLANNING
	_world_timer.pause()
	_world_timer.reset()

func _process(_delta):
	_debug.add_debug_text("tower_defence state", _state)
	_debug.add_debug_text("health", _remaining_health)
	_debug.add_debug_text("remaining_enemies", _remaining_enemies)

	if _state == _tower_defence_states.PLANNING:
		return

	if _state == _tower_defence_states.WAITING_FOR_ENEMY_DEATH:
		if _remaining_enemies == 0:
			end_round()
		return
	
	while _world_timer.seconds() > _next_event_timer:
		if _state == _tower_defence_states.WAITING_FOR_ENEMY_SPAWN:
			_remaining_enemy_spawns = 10
			_change_state(_tower_defence_states.ENEMIES_SPAWNING)

		if _state == _tower_defence_states.ENEMIES_SPAWNING:
			spawn_enemy()
			if _remaining_enemy_spawns <= 0:
				_change_state(_tower_defence_states.WAITING_FOR_ENEMY_DEATH)
				break;
			else:
				_next_event_timer += 0.1

# Start the next round
func start_round():
	if _state == _tower_defence_states.PLANNING:
		_paths.connect_all_paths()
		
		_world_timer.play()
		_next_event_timer = _world_timer.seconds() + 10

		_change_state(_tower_defence_states.WAITING_FOR_ENEMY_SPAWN)

# End this round
func end_round():
	if _state == _tower_defence_states.WAITING_FOR_ENEMY_DEATH:
		_paths.disconnect_all_paths()

		for resource in _main_scene.get_children_in_groups(_terrain, [_groups.RESOURCE], true):
			resource.queue_free()

		_world_timer.pause()
		_world_timer.reset()

		_change_state(_tower_defence_states.PLANNING)

# Change the state of the tower defence part of the game
func _change_state(new_state):
	_state = new_state

# Spawn an enemy. Each enemy spawn behavour is handled by the enemy itself.
func spawn_enemy():	
	_main_scene.create_node(enemy_path, _enemies)
	_remaining_enemies += 1
	_remaining_enemy_spawns -= 1

# Take damage from an enemy reaching the reactor
func take_damage():
	_remaining_health -= 1
	if _remaining_health == 0:
		_world_timer.stop()

# Call this when an enemy dies
func enemy_died():
	_remaining_enemies -= 1

# Skip to the next wave, mostly for debug reasons
func skip_to_next_wave():
	return


