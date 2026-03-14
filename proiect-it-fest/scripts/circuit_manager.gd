extends Node

func evaluate_circuits() -> void:
	print("--- Recalculating Power ---")
	var wires = get_tree().get_nodes_in_group("wires")
	var components = get_tree().get_nodes_in_group("components")

	# Turn everything off first
	for comp in components:
		comp.is_powered = false
		comp.current_voltage = 0.0
		if comp.get("debug_label"):
			if comp.get("is_battery"):
				comp.debug_label.text = str(comp.voltage_output) + "V"
			else:
				comp.debug_label.text = "0V"

	var graph = {}

	# 1. Map all wire connections
	for wire in wires:
		if not graph.has(wire.term_a): graph[wire.term_a] = []
		if not graph.has(wire.term_b): graph[wire.term_b] = []
		
		graph[wire.term_a].append(wire.term_b)
		graph[wire.term_b].append(wire.term_a)

	# 2. Map internal component connections safely
	for comp in components:
		# Bypass the Godot duplication bug by finding the actual child nodes
		var real_terminals = []
		for child in comp.get_children():
			if child is Marker2D and child.is_in_group("terminals"):
				real_terminals.append(child)
		
		# If we found both, connect them and update the broken variables
		if real_terminals.size() == 2:
			var t_left = real_terminals[0]
			var t_right = real_terminals[1]
			
			comp.terminal_left = t_left
			comp.terminal_right = t_right
			
			if not graph.has(t_left): graph[t_left] = []
			if not graph.has(t_right): graph[t_right] = []
			
			graph[t_left].append(t_right)
			graph[t_right].append(t_left)

	# 3. Find batteries and trace their loops
	for comp in components:
		if comp.get("is_battery"):
			_trace_circuit(comp, graph)

func _trace_circuit(start_battery: Node, graph: Dictionary) -> void:
	var start_node = start_battery.terminal_right
	var target_node = start_battery.terminal_left
	
	if not graph.has(start_node) or not graph.has(target_node):
		return
		
	var queue = [[start_node]] 
	var valid_loops = []
	
	while queue.size() > 0:
		var path = queue.pop_front()
		var current = path.back()
		
		if current == target_node:
			if path.size() > 2:
				valid_loops.append(path)
			continue
			
		for neighbor in graph[current]:
			if not neighbor in path: 
				var new_path = path.duplicate()
				new_path.append(neighbor)
				queue.append(new_path)
	
	for loop in valid_loops:
		# Start with the power of the battery that initiated the trace
		var total_voltage = start_battery.voltage_output 
		var components_in_loop = []
		
		for node in loop:
			var parent = node.get_parent()
			if not parent in components_in_loop and parent.is_in_group("components"):
				components_in_loop.append(parent)
		
		for comp in components_in_loop:
			# Only check the OTHER batteries in the loop
			if comp.get("is_battery") and comp != start_battery:
				
				var left_idx = loop.find(comp.terminal_left)
				var right_idx = loop.find(comp.terminal_right)
				
				# Flowing Left (-) to Right (+) adds power
				if left_idx < right_idx:
					total_voltage += comp.voltage_output
				# Flowing Right (+) to Left (-) fights the current
				else:
					total_voltage -= comp.voltage_output
				
		print("Loop calculated voltage: ", total_voltage)
				
		for comp in components_in_loop:
			if not comp.get("is_battery"):
				# Use absolute value so the label doesn't say "-9V"
				var display_voltage = abs(total_voltage)
				comp.current_voltage = display_voltage
				
				if comp.get("debug_label"):
					comp.debug_label.text = str(display_voltage) + "V"
					
				# Must have actual power, and must meet the requirement
				if display_voltage > 0.0 and display_voltage >= comp.voltage_required:
					comp.is_powered = true
					print("Powered up: ", comp.name)
