extends Node

var grid_layer : TileMapLayer
var track: Dictionary={}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_layer =  get_tree().get_first_node_in_group("grid")


func get_cell(pos: Vector2)->Vector2i:
	if grid_layer:
		var cell = grid_layer.local_to_map(pos)
		return cell
	return Vector2i()
	
	
func get_coords(cell: Vector2i)-> Vector2:
	if grid_layer:
		return grid_layer.map_to_local(cell)
	return Vector2()


func snap(obj: Node):
	return get_coords(get_cell(obj.global_position))
	
func register(obj: Node):
	var cell = get_cell(obj.global_position)
	track[cell]=obj
	obj.set_meta("current_cell", cell)


func unregister(obj: Node):
	var cell = get_cell(obj.global_position)
	if cell != null and track.get(cell)==obj:
		track.erase(obj)
	obj.remove_meta("current_cell")
		

func move(obj: Node, new_pos: Vector2)->bool:
	var old = obj.get_meta("current_cell")
	if old==null:
		register(obj)
		old = obj.get_meta("current_cell")
		
	var new = get_cell(new_pos)
	if track.has(new) and track[new]!=obj:
		return false
	
	track.erase(old)
	track[new]=obj
	obj.set_meta("current_call", new)
	
	obj.global_position=get_coords(new)
	return true




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
