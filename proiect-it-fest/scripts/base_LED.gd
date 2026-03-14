extends "res://scripts/base_component.gd"
func _process(delta: float) -> void:
	if is_blown:
		sprite.frame = 3 
	else:
		if is_powered:
			sprite.frame = 6 
		else:
			sprite.frame = 0 
