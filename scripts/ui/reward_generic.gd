extends MarginContainer

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

const _card_reward_path = 'res://prefabs/card_rewards/%1.tscn'

var _main_scene
var _reward_choices
var _reward_specific


func _ready():
    _main_scene = get_node(_scene_paths.MAIN_SCENE)
    _reward_choices = get_node(_scene_paths.REWARD_CHOICES)

func initialize(card_reward):
    var path = _card_reward_path.replace('%1', card_reward)
    _reward_specific = _main_scene.create_node(path, self)
    _reward_specific.position = Vector2.ZERO

func select_this():
    _reward_choices.reward_selected(_reward_specific)

