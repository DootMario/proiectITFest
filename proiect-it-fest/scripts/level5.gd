extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Battery", "scene": "res://scenes/sursa.tscn", "count": 2},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 5:\n.I dont like this LED, lets break it! [LEDs have an upper voltage limit, go over it and they break]")


func _unhandled_input(event):
	super._unhandled_input(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for bulb in get_tree().get_nodes_in_group("components"):
		if bulb.scene_file_path=="res://scenes/red_led.tscn" and bulb.sprite.frame==3:
			$Journal_UI.update_and_open("He had it coming...")
			set_process(false)
			await get_tree().create_timer(1.5).timeout
			if Global.nivel_maxim_deblocat<6:
				Global.nivel_maxim_deblocat=6
			get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
