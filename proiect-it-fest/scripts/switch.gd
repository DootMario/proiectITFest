extends "res://scripts/base_component.gd"

var is_switch := true
var is_closed := false
var is_hovering := false

func _ready() -> void:
	super._ready()
	# Track when the mouse is over the component
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_mouse_exited() -> void:
	is_hovering = false

func _input(event: InputEvent) -> void:
	# This runs the dragging and snapping from base_component.gd
	super._input(event)
	
	# Check if we are hovering and pressing E
	if is_hovering and event is InputEventKey and event.keycode == KEY_E and event.pressed and not event.is_echo():
		is_closed = !is_closed
		
		# Change the sprite so players can see it flipped
		if is_closed:
			sprite.frame = 1 # Use your 'closed' frame number
		else:
			sprite.frame = 0 # Use your 'open' frame number
			
		# Call the math directly without the broken safety check
		CircuitManager.evaluate_circuits()
