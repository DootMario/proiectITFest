extends "res://scripts/base_component.gd"

var is_resistor := false

func _ready() -> void:
	super._ready()
	CLICK_TOLERANCE=7.0
	is_resistor = true
func _process(delta: float) -> void:
	pass
