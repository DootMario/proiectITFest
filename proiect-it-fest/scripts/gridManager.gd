extends Node

var grid_layer : TileMapLayer
var occupied_cells := {}

func _ready() -> void:
	grid_layer = get_tree().get_first_node_in_group("grid")

func register(node: Node2D):
	if grid_layer:
		var cell = grid_layer.local_to_map(node.global_position)
		occupied_cells[cell] = node

func unregister(node: Node2D):
	var cells_to_remove = []
	for cell in occupied_cells:
		if occupied_cells[cell] == node:
			cells_to_remove.append(cell)
	for cell in cells_to_remove:
		occupied_cells.erase(cell)

func move(node: Node2D, target_pos: Vector2):
	node.global_position = target_pos

func snap(node: Node2D) -> Vector2:
	if not grid_layer:
		return node.global_position

	var target_cell = grid_layer.local_to_map(node.global_position)

	if occupied_cells.has(target_cell) and occupied_cells[target_cell] != node:
		for cell in occupied_cells:
			if occupied_cells[cell] == node:
				return grid_layer.map_to_local(cell)
		return node.global_position

	unregister(node)
	occupied_cells[target_cell] = node
	return grid_layer.map_to_local(target_cell)
