extends Node2D

var _buildings := preload("res://scripts/library/buildings.gd").new()
var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _cell_states := preload("res://scripts/library/cell_states.gd").new()

var _main_scene
var _terrain
var _debug

var resources = 200


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_debug = get_node(_scene_paths.DEBUG)

func _process(_delta):
	_debug.add_debug_text("resources", resources)

# Place the current building at this coordinate
func place_current_building_at_coord(coord):
	var cell_info = _terrain.get_cell_state(coord)
	var building_dict = _buildings.get_building_by_name("javelin_shooter")

	if _cell_states.BUILDABLE in cell_info and \
		resources >= building_dict["cost"]:

		_terrain.spawn_building(building_dict["prefab_path"], coord)
		resources -= building_dict["cost"]


# Called when the mouse button is pressed on the TileMap.
# func _on_input_event(viewport, event, shape_idx):
# if event is InputEventMouseButton and event.pressed:
# 	var tile_pos = Map.world_to_map(event.position)
