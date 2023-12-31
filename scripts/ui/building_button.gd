extends TextureButton

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var selected_texture: Texture2D
@export var unselected_texture: Texture2D

var _building_placement

var button_type = "building"
var building_name


func _ready():
	_building_placement = get_node(_scene_paths.BUILDING_PLACEMENT)

func _on_pressed():
	get_parent().press_button(self)

func set_selected(selected):
	if selected:
		texture_normal = selected_texture
	else:
		texture_normal = unselected_texture
	