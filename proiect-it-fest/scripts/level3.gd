extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Large Battery", "scene": "res://scenes/sursa_mare.tscn", "count": 1},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 1},
		{"name": "Resistor", "scene": "res://scenes/rezist.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 2:\n.This battery is bigger, you will need to RESIST the current flow somehow.")


func _unhandled_input(event):
	super._unhandled_input(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for bulb in get_tree().get_nodes_in_group("components"):
		if bulb.sprite.frame==6:
			$Journal_UI.set_guide_text("Congratulations!")
			set_process(false)
			get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
