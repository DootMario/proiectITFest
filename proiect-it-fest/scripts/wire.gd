extends Line2D
var term_a : Marker2D
var term_b : Marker2D

func update_wire():
	if term_a and term_b:
		clear_points()
		add_point(term_a.global_position)
		add_point(term_b.global_position)
	print("updated successfully")
	
func delete_wire():
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_wire()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
