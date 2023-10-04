extends HBoxContainer

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _rewards

@export var reward_choice_path: String


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_rewards = get_node(_scene_paths.REWARDS)

func spawn_card_rewards(card_rewards):
	var reward_card = _main_scene.create_node(reward_choice_path, self)
	reward_card.initialize(card_rewards)	

func reward_selected(reward_specific):
	for child in get_children():
		child.queue_free()
	
	_rewards.reward_selected(reward_specific)
