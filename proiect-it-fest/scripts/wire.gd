extends Line2D

var term_a: Marker2D
var term_b: Marker2D
var voltage: float = 0.0

var thickness := 32.0
var area: Area2D
var collision_polygon: CollisionPolygon2D

func _ready():
	width = thickness
	area = Area2D.new()
	collision_polygon = CollisionPolygon2D.new()
	area.add_child(collision_polygon)
	add_child(area)
	area.input_event.connect(_on_area_input)
	update_wire()

## handle voltage transmission
#func supply(obj: Node):
	#pass
	#

func update_wire():
	if term_a and term_b:
		clear_points()
		add_point(term_a.global_position)
		add_point(term_b.global_position)
		update_collision_polygon()

func update_collision_polygon():
	if points.size() < 2:
		return
	var start = points[0]
	var end = points[1]
	var dir = (end - start).normalized()
	var perp = Vector2(-dir.y, dir.x) * (thickness / 2.0)
	var corners = [start + perp, start - perp, end - perp, end + perp]
	collision_polygon.polygon = PackedVector2Array(corners)

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		
		# 1. Mark for death
		queue_free()
		
		# 2. Check for cycles immediately
		CircuitManager.evaluate_circuits()
