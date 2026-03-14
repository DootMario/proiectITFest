extends Button

var item_data: Dictionary

func setup(data: Dictionary):
	item_data = data
	refresh() # Call refresh here instead of manually setting text
	pressed.connect(_on_pressed)

# 1. New function to update text and disabled state
func refresh():
	var count = item_data.get("count", 0)
	text = item_data.get("name", "Item") + " (" + str(count) + ")"
	disabled = (count <= 0)

func _on_pressed():
	if disabled: 
		return # Failsafe
		
	var scene_path = item_data.get("scene", "")
	if GameState.selected_scene_path == scene_path:
		# Deselect if already selected
		GameState.selected_scene_path = ""
		print("Deselected ", item_data.get("name"))
	else:
		# Select new item
		GameState.selected_scene_path = scene_path
		print("Selected ", item_data.get("name"))
