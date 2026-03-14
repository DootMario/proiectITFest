
extends "res://scripts/base_LED.gd"
func _process(delta: float) -> void:
	if is_blown:
		sprite.frame = 3 
	else:
		if is_powered:
			sprite.frame = 6 # Assuming frame 1 is 'on'
		else:
			sprite.frame = 0 # Assuming frame 0 is 'off'


func _ready() -> void:
	super._ready()
	# Force the requirement so Godot can't forget it
	voltage_required = 18.0
