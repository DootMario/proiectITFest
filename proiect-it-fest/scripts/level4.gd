extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Battery", "scene": "res://scenes/sursa.tscn", "count": 2},
		{"name": "Green LED", "scene": "res://scenes/green_led.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 4:\n.Now the LED seems to need more power, luckly we have more batteries, just put them in series [one connected to the next].")


func _unhandled_input(event):
	super._unhandled_input(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for bulb in get_tree().get_nodes_in_group("components"):
		if bulb.scene_file_path=="res://scenes/green_led.tscn" and bulb.sprite.frame==6:
			$Journal_UI.update_and_open("I knew you could do it!")
			set_process(false)
			await get_tree().create_timer(1.5).timeout
			if Global.nivel_maxim_deblocat<5:
				Global.nivel_maxim_deblocat=5
			get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
