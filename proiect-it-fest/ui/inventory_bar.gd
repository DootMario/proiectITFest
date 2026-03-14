extends CanvasLayer

@onready var slot_container = $Background/SlotContainer
var slot_scene = preload("res://ui/inventory_slot.tscn")  # adjust path if needed

func set_items(items: Array) -> void:
	if slot_container == null:
		push_error("slot_container is null!")
		return

	# Remove old slots
	for child in slot_container.get_children():
		child.queue_free()

	# Create new slots
	for item in items:
		var slot = slot_scene.instantiate()
		slot.setup(item)
		slot_container.add_child(slot)
