extends TextureButton

@export var selected_texture: Texture2D
@export var unselected_texture: Texture2D

var button_type = "tool"
@export var tool_name: String


func _on_pressed():
	get_parent().press_button(self)

func set_selected(selected):
	if selected:
		texture_normal = selected_texture
	else:
		texture_normal = unselected_texture

