extends "res://scripts/base_component.gd"
func _process(delta: float) -> void:
	if is_powered:
		sprite.frame = 6 # Assuming frame 1 is 'on'
	else:
		sprite.frame = 0 # Assuming frame 0 is 'off'
