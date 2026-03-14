extends Node

var grid_layer: TileMapLayer
var cell_to_node: Dictionary = {}   # Vector2i -> Node2D
var node_to_cell: Dictionary = {}   # Node2D -> Vector2i

func _ready() -> void:
	grid_layer = get_tree().get_first_node_in_group("grid")

func register(node: Node2D) -> void:
	if not grid_layer:
		return
	var cell = grid_layer.local_to_map(node.global_position)
	cell_to_node[cell] = node
	node_to_cell[node] = cell

func unregister(node: Node2D) -> void:
	if not node_to_cell.has(node):
		return
	var cell = node_to_cell[node]
	cell_to_node.erase(cell)
	node_to_cell.erase(node)

func move(node: Node2D, target_pos: Vector2) -> void:
	node.global_position = target_pos

func snap(node: Node2D) -> Vector2:
	if not grid_layer:
		return node.global_position

	var old_cell = node_to_cell.get(node)
	var target_cell = grid_layer.local_to_map(node.global_position)

	# free cell or occupied by node itself
	if not cell_to_node.has(target_cell) or cell_to_node[target_cell] == node:
		if old_cell != null and old_cell != target_cell:
			cell_to_node.erase(old_cell)
		cell_to_node[target_cell] = node
		node_to_cell[node] = target_cell
		return grid_layer.map_to_local(target_cell)

	if old_cell != null:
		return grid_layer.map_to_local(old_cell)
	return node.global_position
