extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Large Battery", "scene": "res://scenes/sursa_mare.tscn", "count": 2},
		{"name": "Green LED", "scene": "res://scenes/green_led.tscn", "count": 1},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 1},
		{"name": "Switch", "scene": "res://scenes/switch.tscn", "count": 1},
		{"name": "Resistor", "scene": "res://scenes/rezist.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 7:\n.All togher now everything you learned up till now! Light both LEDs and use a switch, cus i feel like it.")


func _unhandled_input(event):
	super._unhandled_input(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bulbs := 0
	for bulb in get_tree().get_nodes_in_group("components"):
		if (bulb.scene_file_path=="res://scenes/red_led.tscn" and bulb.sprite.frame==6) or (bulb.scene_file_path=="res://scenes/green_led.tscn" and bulb.sprite.frame==6):
			bulbs +=1
			
	for component in get_tree().get_nodes_in_group("components"):
		# If the component is a switch, call our new function
		if component.get("is_switch") == true:
			if component.is_connected_to_both():
				for bulb in get_tree().get_nodes_in_group("components"):
					if bulb.scene_file_path == "res://scenes/red_led.tscn" and bulb.sprite.frame==6 and bulbs == 2:
						$Journal_UI.set_guide_text("You really are good at this...")
						set_process(false)
						get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
		
