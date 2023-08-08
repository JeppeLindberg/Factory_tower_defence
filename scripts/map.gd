extends TileMap

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _groups := preload("res://scripts/library/groups.gd").new()

var _main_scene
var _terrain
var _behaviour_nodes

@export var enemy_spawner_path: String
@export var enemy_target_path: String

var _used_cell_coords


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_behaviour_nodes = _terrain.get_node("behaviour_nodes")

	# Creates an array of Vector2i's that represent all the coordinates that has a tile
	_used_cell_coords = get_used_cells(0)

	_create_behavour_nodes()

# Creates all behavour nodes in the scene, according to the custom data element "type"
func _create_behavour_nodes():
	for cell_coord in _used_cell_coords:
		var data: TileData = get_cell_tile_data(0, cell_coord)
		var cell_pos = _main_scene.cell_coord_to_pos(cell_coord)
		
		var type = data.get_custom_data("type")
		if type:
			var new_node: Node2D

			# The types are assigned based on the groups in groups.gd
			match type:
				_groups.ENEMY_SPAWNER:
					new_node = _main_scene.create_node(enemy_spawner_path, _behaviour_nodes)
				_groups.ENEMY_TARGET:
					new_node = _main_scene.create_node(enemy_target_path, _behaviour_nodes)

			new_node.global_position = cell_pos + _main_scene.quadrant_size() * 0.5
			new_node.add_to_group(type)

					

