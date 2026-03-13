extends Line2D
var term_a : Marker2D
var term_b : Marker2D
var THICC := 20.0
var area: Area2D
var polygon: CollisionPolygon2D
var voltage := 0.0

func update_wire():
	if term_a and term_b:
		clear_points()
		add_point(term_a.global_position)
		add_point(term_b.global_position)
		update_polygon()
	

func update_polygon():
	if points.size()<2:
		return
	var start = points[0]
	var end = points[1]
	var dir = (end-start).normalized()
	var perp = Vector2(-dir.y, dir.x)*(THICC/2)
	var corners = [start+perp, start-perp, end-perp, end+perp]
	polygon.polygon = PackedVector2Array(corners)


func _on_area_input(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		queue_free()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = THICC
	area = Area2D.new()
	polygon = CollisionPolygon2D.new()
	area.add_child(polygon)
	add_child(area)
	area.input_event.connect(_on_area_input)
	update_wire()
	print(voltage)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
