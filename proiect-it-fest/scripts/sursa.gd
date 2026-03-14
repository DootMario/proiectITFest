extends "res://scripts/base_component.gd"

@export var voltage: float = 0.0

# Override to pass the voltage to the wire
func create_wire(from: Marker2D, to: Marker2D) -> void:
	var wire_scene = preload("res://scenes/wire.tscn")
	var wire = wire_scene.instantiate()
	wire.term_a = from
	wire.term_b = to
	wire.voltage = voltage
	wire.add_to_group("wires")
	get_tree().current_scene.add_child(wire)
