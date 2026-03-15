extends Camera2D


var move_speed:=300
var zoom_speed:=0.1
var min_zoom:=0.5
var max_zoom:=4.0
var max_mvmt:=256
var start_pos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos=position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = Input.get_vector("camera_left","camera_right","camera_up","camera_down")
	position+=dir*move_speed*delta/(zoom.x*0.5)
	position.x = clamp(position.x, start_pos.x-max_mvmt, start_pos.x+max_mvmt)
	position.y = clamp(position.y, start_pos.y-max_mvmt, start_pos.y+max_mvmt)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom+=Vector2(zoom_speed, zoom_speed)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom-=Vector2(zoom_speed, zoom_speed)
			
		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)
			
