extends "res://scripts/base_LED.gd"
func _ready() -> void:
	super._ready()
	# Force the requirement so Godot can't forget it
	voltage_required = 9.0
