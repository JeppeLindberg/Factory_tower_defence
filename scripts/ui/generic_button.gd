extends Control

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _controller


func activate():
	_controller = get_node(_scene_paths.CONTROLLER)
	_controller.add_button(get_child(0))

func press_button(button):
	_controller.press_button(button)

func _on_mouse_entered():
	_controller.hover_ui()
