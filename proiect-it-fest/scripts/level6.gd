extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Battery", "scene": "res://scenes/sursa.tscn", "count": 1},
		{"name": "Large Battery", "scene": "res://scenes/sursa_mare.tscn", "count": 1},
		{"name": "Green LED", "scene": "res://scenes/green_led.tscn", "count": 1},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 6:\n.LEDs can be put in series too, light both of them up.")


func _unhandled_input(event):
	super._unhandled_input(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bulbs := 0
	for bulb in get_tree().get_nodes_in_group("components"):
		if (bulb.scene_file_path=="res://scenes/red_led.tscn" and bulb.sprite.frame==6) or (bulb.scene_file_path=="res://scenes/green_led.tscn" and bulb.sprite.frame==6):
			bulbs +=1
	if bulbs==2:
		$Journal_UI.set_guide_text("They are holding hands <3...")
		set_process(false)
		get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
