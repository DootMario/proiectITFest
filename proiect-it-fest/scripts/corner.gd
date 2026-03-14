extends Area2D
@export var voltage := 0.0
var dragging := false
var drag_offset := Vector2.ZERO
const TOLERANCE := 10.0
var wiring := false
var wire_start : Marker2D = null
var temp_wire : Line2D = null
var con1 : Marker2D
var con2 : Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	con1 = $Con1
	con2 = $Con2
	# snaping sistem
	GridManager.register(self)
	
	
func _exit_tree() -> void:
	GridManager.unregister(self)
	
	
func init(volts: float)->void:
	voltage=volts
	
func terminal(pos: Vector2)->Marker2D:
	var terms = get_tree().get_nodes_in_group("terminals")
	var mark : Marker2D = null
	for t in terms:
		if pos.distance_to(t.global_position)<=TOLERANCE:
			mark=t
	
	return mark
	
func start_wire(start: Marker2D):
	wiring = true
	wire_start=start
	temp_wire = Line2D.new()
	temp_wire.width = 2
	temp_wire.default_color = Color.RED
	temp_wire.add_point(wire_start.global_position)
	temp_wire.add_point(wire_start.global_position)
	get_tree().current_scene.add_child(temp_wire)


func continue_wire(end_pos:Vector2):
	if temp_wire and temp_wire.points.size()==2:
		temp_wire.set_point_position(1, end_pos)
		
		
func already(term_a: Marker2D, term_b: Marker2D)->bool:
	for con in get_tree().get_nodes_in_group("wires"):
		if [con.term_a, con.term_b]==[term_a, term_b] or [con.term_a, con.term_b]==[term_b, term_a]:
			return true
	return false
	
	
func end_wire(release_pos: Vector2):
	var end_mark = terminal(release_pos)
	if end_mark!=null and end_mark!=wire_start and not already(wire_start, end_mark):
		create_perm_wire(wire_start, end_mark)
	if temp_wire:
		temp_wire.queue_free()
		temp_wire = null
	wiring = false
	wire_start=null	


func create_perm_wire(from: Marker2D, to: Marker2D):
	var wire_scene = preload("res://scenes/wire.tscn")
	var wire = wire_scene.instantiate()
	wire.term_a=from
	wire.term_b=to
	wire.voltage = voltage
	wire.add_to_group("wires")
	get_tree().current_scene.add_child(wire)
	
	
func update_cons():
	var cons = get_tree().get_nodes_in_group("wires")
	for connection in cons:
		if connection.term_a == con1 or connection.term_a == con2 or connection.term_b == con1 or connection.term_b == con2:
			connection.update_wire()
	
	
func _on_input_event(viewport: Node, event: InputEvent, shape_id: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()

		if event.pressed:
			for cell in GridManager.occupied_cells:
				var other_source = GridManager.occupied_cells[cell]
				if is_instance_valid(other_source) and other_source != self:
					if other_source.wiring or other_source.dragging:
						return

			var clicked_mark = terminal(mouse_pos)
			if clicked_mark!=null:
				start_wire(clicked_mark)
				return
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			if wiring:
				end_wire(mouse_pos)
			dragging = false
			#snapping sistem
			global_position = GridManager.snap(self)
			update_cons()
			
func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseMotion:
		var target = get_global_mouse_position()+drag_offset
		GridManager.move(self, target)
		update_cons()
	if wiring and event is InputEventMouseMotion:
		continue_wire(get_global_mouse_position())
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		if wiring:
			end_wire(get_global_mouse_position())
		wiring = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
