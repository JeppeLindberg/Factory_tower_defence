extends Node2D

var show_grid = false
var _debug_text_dict = {}

var _map
var _debug_text
var _draw_lines = []


func _ready():
	_map = get_node("/root/main_scene/terrain/map")
	_debug_text = get_node("debug_ui_control/debug_text")

func _process(_delta):
	_debug_text.text = ""
	for key in _debug_text_dict:
		_debug_text.text += key + ": " + str(_debug_text_dict[key]) + "\n"

func add_debug_text(indentifier, text):
	_debug_text_dict[indentifier] = text

func add_draw_line(pos_a, pos_b, color = Color.DARK_RED):
	_draw_lines.append({"pos_a": pos_a, "pos_b": pos_b, "color": color})

# A default function where you draw debug info
func _draw():
	if show_grid == true:
		for x in range(0,100):
			var from = Vector2.RIGHT * x * _map.cell_quadrant_size
			var to = Vector2.RIGHT * x * _map.cell_quadrant_size + Vector2.DOWN * 10000
			draw_line(from, to, Color.BLACK)
		
		for y in range(0,100):
			var from = Vector2.DOWN * y * _map.cell_quadrant_size
			var to = Vector2.DOWN * y * _map.cell_quadrant_size + Vector2.RIGHT * 10000
			draw_line(from, to, Color.BLACK)

