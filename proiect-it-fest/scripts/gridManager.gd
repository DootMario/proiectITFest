extends Node

var grid_layer : TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_layer =  get_tree().get_first_node_in_group("grid")


func snap(pos: Vector2):
	if grid_layer:
		var cell = grid_layer.local_to_map(pos)
		return grid_layer.map_to_local(cell)
	return pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
