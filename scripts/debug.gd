extends Node2D

var show_grid = false

var _map


func _ready():
	_map = get_node("/root/main_scene/terrain/map")

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

