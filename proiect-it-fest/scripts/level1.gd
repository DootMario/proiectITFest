extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Battery", "scene": "res://scenes/sursa.tscn", "count": 1},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 1:\nConnect the Battery to the Red LED [from your inventory upstairs] using the wire tool [click and drag on their terminals]")

func _unhandled_input(event):
	super._unhandled_input(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child in get_children():
		if child.scene_file_path == "res://scenes/red_led.tscn" and child.sprite.frame==6:
			$Journal_UI.update_and_open("Puzzle Solved! LED is turned on!")
			set_process(false)
			await get_tree().create_timer(1.5).timeout
			if Global.nivel_maxim_deblocat<2:
				Global.nivel_maxim_deblocat=2
			get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
		
