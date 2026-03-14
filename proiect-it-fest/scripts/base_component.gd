extends Area2D

# Common state
var dragging := false
var drag_offset := Vector2.ZERO
var wiring := false
var wire_start: Marker2D = null
var temp_wire: Line2D = null

# Terminals – assign in the scene (two Marker2D children)
@export var terminal_left: Marker2D
@export var terminal_right: Marker2D

const CLICK_TOLERANCE := 10.0

func _ready() -> void:
	input_event.connect(_on_input_event)
	GridManager.register(self)

func _exit_tree() -> void:
	GridManager.unregister(self)

# Find which terminal (if any) is near a given world position
func get_terminal_at(pos: Vector2) -> Marker2D:
	var all_terminals = get_tree().get_nodes_in_group("terminals")
	var closest: Marker2D = null
	var min_dist = CLICK_TOLERANCE
	for t in all_terminals:
		var dist = pos.distance_to(t.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = t
	return closest

# Start drawing a wire from a terminal
func start_wire(start: Marker2D) -> void:
	wiring = true
	wire_start = start
	temp_wire = Line2D.new()
	temp_wire.width = 2
	temp_wire.default_color = Color.RED
	temp_wire.add_point(wire_start.global_position)
	temp_wire.add_point(wire_start.global_position)
	get_tree().current_scene.add_child(temp_wire)

# Update the temporary wire while mouse moves
func continue_wire(end_pos: Vector2) -> void:
	if temp_wire and temp_wire.points.size() == 2:
		temp_wire.set_point_position(1, end_pos)

# Check if a wire already exists between two terminals
func connection_exists(a: Marker2D, b: Marker2D) -> bool:
	for wire in get_tree().get_nodes_in_group("wires"):
		if (wire.term_a == a and wire.term_b == b) or (wire.term_a == b and wire.term_b == a):
			return true
	return false

# Finish drawing: create a permanent wire if conditions are met
func end_wire(release_pos: Vector2) -> void:
	var end_mark = get_terminal_at(release_pos)
	if end_mark and end_mark != wire_start and not connection_exists(wire_start, end_mark):
		create_wire(wire_start, end_mark)
	if temp_wire:
		temp_wire.queue_free()
		temp_wire = null
	wiring = false
	wire_start = null

# Override this in child classes to create a wire with custom data (e.g., voltage)
func create_wire(from: Marker2D, to: Marker2D) -> void:
	var wire_scene = preload("res://scenes/wire.tscn")
	var wire = wire_scene.instantiate()
	wire.term_a = from
	wire.term_b = to
	wire.add_to_group("wires")
	get_tree().current_scene.add_child(wire)

# Update all wires attached to this component’s terminals
func update_connected_wires() -> void:
	for wire in get_tree().get_nodes_in_group("wires"):
		if wire.term_a in [terminal_left, terminal_right] or wire.term_b in [terminal_left, terminal_right]:
			wire.update_wire()

# Called when the component itself is clicked
func _on_input_event(viewport: Node, event: InputEvent, shape_id: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()

		if event.pressed:
			# Prevent interaction if any other component is busy (dragging/wiring)
			for cell in GridManager.cell_to_node:
				var other = GridManager.cell_to_node[cell]
				if is_instance_valid(other) and other != self and other.has_method("is_busy") and other.is_busy():
					return

			var clicked_term = get_terminal_at(mouse_pos)
			if clicked_term:
				start_wire(clicked_term)
				return

			# Start dragging the component
			dragging = true
			drag_offset = global_position - mouse_pos
		else:
			if wiring:
				end_wire(mouse_pos)
			dragging = false
			# Snap to grid after release
			global_position = GridManager.snap(self)
			update_connected_wires()
	if Input.is_action_just_pressed("rotate_block"):
		rotation+=PI/2

# Global input handling (mouse motion, release anywhere)
func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseMotion:
		var target = get_global_mouse_position() + drag_offset
		GridManager.move(self, target)
		update_connected_wires()
	if wiring and event is InputEventMouseMotion:
		continue_wire(get_global_mouse_position())
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		if wiring:
			end_wire(get_global_mouse_position())
		wiring = false

# Helper for other components to check if this one is busy
func is_busy() -> bool:
	return dragging or wiring
