extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Battery", "scene": "res://scenes/sursa.tscn", "count": 1},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 1},
		{"name": "Switch", "scene": "res://scenes/switch.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 2:\nSWITCH[component] the red LED on.")


func _unhandled_input(event):
	super._unhandled_input(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for component in get_tree().get_nodes_in_group("components"):
		# If the component is a switch, call our new function
		if component.get("is_switch") == true:
			if component.is_connected_to_both():
				for bulb in get_tree().get_nodes_in_group("components"):
					if bulb.scene_file_path == "res://scenes/red_led.tscn" and bulb.sprite.frame==6:
						$Journal_UI.set_guide_text("Puzzle Solved! Switch is wired to both Sursa and LED.")
						set_process(false)
						get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
