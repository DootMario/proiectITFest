extends Button

var item_data: Dictionary

func setup(data: Dictionary):
	item_data = data
	text = data.get("name", "Item")
	pressed.connect(_on_pressed)

func _on_pressed():
	var scene_path = item_data.get("scene", "")
	if GameState.selected_scene_path == scene_path:
		# Deselect if already selected
		GameState.selected_scene_path = ""
		print("Deselected ", item_data.get("name"))
	else:
		# Select new item
		GameState.selected_scene_path = scene_path
		print("Selected ", item_data.get("name"))
