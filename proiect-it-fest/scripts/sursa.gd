extends "res://scripts/base_component.gd"

@export var supply_voltage: float = 0.0

# handle pd
func create_wire(from: Marker2D, to: Marker2D) -> void:
	var wire_scene = preload("res://scenes/wire.tscn")
	var wire = wire_scene.instantiate()
	wire.term_a = from
	wire.term_b = to
	wire.voltage = supply_voltage
	wire.add_to_group("wires")
	get_tree().current_scene.add_child(wire)
	sprite.frame=1
	to.get_parent().sprite.frame=1
	cons+=1
	to.get_parent().cons+=1
	wire.supply(to)
