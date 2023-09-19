extends TextureButton

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var selected_texture: Texture2D
@export var unselected_texture: Texture2D

var _building_placement

var building_name


func _ready():
	pass

func _on_pressed():
	get_parent().press_button(self)

func _process(_delta):
	pass

