extends Node

# This locks the door so the math can't run twice at the same time
var is_evaluating := false

func evaluate_circuits() -> void:
	if is_evaluating:
		return
	is_evaluating = true
	
	# Force the engine to wait a frame so every wire is completely loaded
	await get_tree().process_frame

	var wires = get_tree().get_nodes_in_group("wires")
	var components = get_tree().get_nodes_in_group("components")

	for comp in components:
		comp.is_powered = false

	var graph = {}

	# 1. Grab and physically sort the terminals
	for comp in components:
		var real_terminals = []
		for child in comp.get_children():
			if child is Marker2D and child.is_in_group("terminals"):
				real_terminals.append(child)
		
		if real_terminals.size() >= 2:
			if real_terminals[0].global_position.x > real_terminals[1].global_position.x:
				comp.terminal_left = real_terminals[1]
				comp.terminal_right = real_terminals[0]
			else:
				comp.terminal_left = real_terminals[0]
				comp.terminal_right = real_terminals[1]
				
			var t_left = comp.terminal_left
			var t_right = comp.terminal_right
			
			if not graph.has(t_left): graph[t_left] = []
			if not graph.has(t_right): graph[t_right] = []
			
			graph[t_left].append(t_right)
			graph[t_right].append(t_left)

	# 2. Map wires
	for wire in wires:
		if wire.is_queued_for_deletion():
			continue
			
		var t_a = wire.term_a
		var t_b = wire.term_b
		
		if not graph.has(t_a): graph[t_a] = []
		if not graph.has(t_b): graph[t_b] = []
		
		graph[t_a].append(t_b)
		graph[t_b].append(t_a)

	# 3. Find perfect rings
	var visited = []
	var loops = []
	
	for start_node in graph.keys():
		if start_node in visited:
			continue
			
		var island = []
		var queue = [start_node]
		var is_perfect_loop = true
		
		while queue.size() > 0:
			var curr = queue.pop_front()
			if curr in island:
				continue
			island.append(curr)
			
			if graph[curr].size() != 2:
				is_perfect_loop = false
				
			for neighbor in graph[curr]:
				if not neighbor in island and not neighbor in queue:
					queue.append(neighbor)
					
		visited.append_array(island)
		
		if is_perfect_loop and island.size() > 2:
			loops.append(island)

	# 4. Power up
	for island in loops:
		var ordered_path = []
		var curr = island[0]
		var prev = null
		
		for i in range(island.size()):
			ordered_path.append(curr)
			var next_node = null
			for neighbor in graph[curr]:
				if neighbor != prev:
					next_node = neighbor
					break
			prev = curr
			curr = next_node

		var total_voltage = 0.0
		var loop_req_voltage = 0.0
		var components_in_loop = []
		
		for node in ordered_path:
			var comp = node.get_parent()
			if comp.is_in_group("components") and not comp in components_in_loop:
				components_in_loop.append(comp)
				
		for comp in components_in_loop:
			if comp.get("is_battery"):
				var left_idx = ordered_path.find(comp.terminal_left)
				var right_idx = ordered_path.find(comp.terminal_right)
				
				# Safer math check that won't break if the loop is built backward
				var path_size = ordered_path.size()
				var diff = (right_idx - left_idx + path_size) % path_size
				
				if diff == 1:
					total_voltage += comp.voltage_output
				elif diff == path_size - 1:
					total_voltage -= comp.voltage_output
			else:
				loop_req_voltage += comp.voltage_required

		var display_voltage = abs(total_voltage)
		print("Ring! Power: ", display_voltage, "V | Required: ", loop_req_voltage, "V")
		
		for comp in components_in_loop:
			if not comp.get("is_battery"):
				if display_voltage > 0.0 and display_voltage >= loop_req_voltage:
					comp.is_powered = true
					
	# Unlock the door so it can run again later
	is_evaluating = false
