extends Node2D

var items = []

func _ready():
	# NEW: Add this level to a group so components can easily find it
	add_to_group("level") 
	
	items = [
		{"name": "Battery", "scene": "res://scenes/sursa.tscn", "count": 2},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 5}
	]
	$InventoryBar.set_items(items)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.selected_scene_path == "":
			return
			
		var current_item = null
		for item in items:
			if item.get("scene") == GameState.selected_scene_path:
				current_item = item
				break
				
		if current_item == null or current_item.get("count", 0) <= 0:
			GameState.selected_scene_path = ""
			return

		var mouse_pos = get_global_mouse_position()
		var scene = load(GameState.selected_scene_path)
		if scene == null:
			push_error("Failed to load scene: ", GameState.selected_scene_path)
			return
			
		var instance = scene.instantiate()
		instance.global_position = mouse_pos
		
		# NEW: Tag the instance with its scene path so it knows what it is later
		instance.set_meta("scene_path", GameState.selected_scene_path)
		
		add_child(instance)
		
		current_item["count"] -= 1
		$InventoryBar.refresh_slots()

		GameState.selected_scene_path = ""

# NEW: Function that components will call when they are right-clicked
func return_item(scene_path: String) -> void:
	for item in items:
		if item.get("scene") == scene_path:
			item["count"] += 1
			$InventoryBar.refresh_slots()
			break
