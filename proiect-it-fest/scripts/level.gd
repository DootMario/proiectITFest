extends Node2D

func _ready():
	# Define items for this level
	var items = [
		{"name": "Battery", "scene": "res://scenes/sursa.tscn"},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn"}
	]
	$InventoryBar.set_items(items)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.selected_scene_path == "":
			return

		var mouse_pos = get_global_mouse_position()
		var scene = load(GameState.selected_scene_path)
		if scene == null:
			push_error("Failed to load scene: ", GameState.selected_scene_path)
			return
		var instance = scene.instantiate()
		instance.global_position = mouse_pos
		add_child(instance)

		# Optional: deselect after placing one item
		GameState.selected_scene_path = ""
