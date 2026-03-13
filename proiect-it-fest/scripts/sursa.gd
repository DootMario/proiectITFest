extends Area2D
var voltage := 0.0
var dragging := false
var drag_offset := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	
	
func init(volts: float)->void:
	voltage=volts
	

func _on_input_event(viewport: Node, event: InputEvent, shape_id: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false
			
			
func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseMotion:
		var target = get_global_mouse_position()+drag_offset
		global_position = target



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
