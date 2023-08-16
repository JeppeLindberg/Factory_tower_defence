extends Node2D

var show_grid = true
var show_draw_lines = true
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

	queue_redraw()

func add_debug_text(indentifier, text):
	_debug_text_dict[indentifier] = text

func add_draw_line(pos_a, pos_b, color = Color.DARK_RED):
	var line = {"pos_a": pos_a, "pos_b": pos_b, "color": color}
	if !_draw_lines.has(line):
		_draw_lines.append({"pos_a": pos_a, "pos_b": pos_b, "color": color})

# A default function where you draw debug info
func _draw():
	if show_grid:
		for x in range(0,100):
			var from = Vector2.RIGHT * x * _map.cell_quadrant_size
			var to = Vector2.RIGHT * x * _map.cell_quadrant_size + Vector2.DOWN * 10000
			draw_line(from, to, Color.BLACK)
		
		for y in range(0,100):
			var from = Vector2.DOWN * y * _map.cell_quadrant_size
			var to = Vector2.DOWN * y * _map.cell_quadrant_size + Vector2.RIGHT * 10000
			draw_line(from, to, Color.BLACK)
	
	if show_draw_lines:
		for line in _draw_lines:
			var from = line["pos_a"]
			var to = line["pos_b"]
			draw_line(from, to, line["color"])
	
	_draw_lines = []

