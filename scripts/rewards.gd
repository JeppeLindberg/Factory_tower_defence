extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _rounds := preload("res://scripts/library/rounds.gd").new()

var _building_placement
var _tower_defence

var _continue
var _reward_index = 0
var _round_rewards = {}


func activate():
	_building_placement = get_node(_scene_paths.BUILDING_PLACEMENT)
	_tower_defence = get_node(_scene_paths.TOWER_DEFENCE)

func _process(_delta):
	if _continue:
		_continue = false
		
		if _reward_index == 0:
			if _round_rewards.get("resources", false):
				var add_resources = _round_rewards["resources"]
				
				_building_placement.add_resources(add_resources)

			continue_giving_rewards()
			return
		
		if _reward_index == 1:
			if _round_rewards.get("card_reward", false):
				# continue_giving_rewards()
				return
			else:
				continue_giving_rewards()
				return

		if _reward_index == 2:
			_tower_defence.finish_handling_rewards()

# Begin the process of giving rewards
func give_rewards(round_index):
	_round_rewards = _rounds.get_wave_by_index(round_index)["rewards"]
	_reward_index = 0
	_continue = true

# Continue giving rewards after pausing control from this script
func continue_giving_rewards():
	_continue = true
	_reward_index += 1

