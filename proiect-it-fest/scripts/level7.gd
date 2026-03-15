extends "res://scripts/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.clear_grid()
	add_to_group("level")
	
	items = [
		{"name": "Large Battery", "scene": "res://scenes/sursa_mare.tscn", "count": 2},
		{"name": "Green LED", "scene": "res://scenes/green_led.tscn", "count": 1},
		{"name": "Red LED", "scene": "res://scenes/red_led.tscn", "count": 1},
		{"name": "Switch", "scene": "res://scenes/switch.tscn", "count": 1},
		{"name": "Resistor", "scene": "res://scenes/rezist.tscn", "count": 1}
	]
	$InventoryBar.set_items(items)
	if has_node("Journal_UI"):
		$Journal_UI.set_guide_text("Puzzle 7:\n.All togher now everything you learned up till now! Light both LEDs and use a switch, cus i feel like it.")


func _unhandled_input(event):
	super._unhandled_input(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_red_lit := false
	var is_green_lit := false
	var is_switch_ready := false
	
	# Loop through components exactly once per frame
	for comp in get_tree().get_nodes_in_group("components"):
		
		# 1. Check for a lit red LED
		if comp.scene_file_path == "res://scenes/red_led.tscn" and comp.sprite.frame == 6:
			is_red_lit = true
			
		# 2. Check for a lit green LED
		elif comp.scene_file_path == "res://scenes/green_led.tscn" and comp.sprite.frame == 6:
			is_green_lit = true
			
		# 3. Check for the switch
		elif comp.get("is_switch") == true:
			if comp.is_closed:
				is_switch_ready = true

	# 4. If all three conditions are met
	if is_red_lit and is_green_lit and is_switch_ready:
		set_process(false)
		if has_node("Journal_UI"):
			$Journal_UI.update_and_open("You really are good at this...")
			
		# Wait 1.5 seconds so the player can actually see the LEDs light up and read the text
		await get_tree().create_timer(1.5).timeout 
		get_tree().change_scene_to_file("res://scenes/SelectorNivele.tscn")
		
