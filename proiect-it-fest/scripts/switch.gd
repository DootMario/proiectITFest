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
		
func is_connected_to_both() -> bool:
	var connected_to_sursa = false
	var connected_to_led = false
	
	# Loop through all wires in the level
	for wire in get_tree().get_nodes_in_group("wires"):
		var other_terminal: Marker2D = null
		
		# Check if the wire is connected to either of the switch's terminals
		if wire.term_a in [terminal_left, terminal_right]:
			other_terminal = wire.term_b # The other end is term_b
		elif wire.term_b in [terminal_left, terminal_right]:
			other_terminal = wire.term_a # The other end is term_a
			
		# If the wire is attached to this switch, let's identify what's on the other side
		if other_terminal != null:
			# Get the component node that owns this terminal
			var other_component = other_terminal.get_parent()
			
			# Check if it's a Sursa/Battery
			if other_component.get("is_battery") == true:
				connected_to_sursa = true
				
			# Check if it's a Red LED (Checks the file it was spawned from)
			if other_component.scene_file_path != null and "red_led.tscn" in other_component.scene_file_path:
				connected_to_led = true
				
	# Return true ONLY if we found both!
	return connected_to_sursa and connected_to_led
