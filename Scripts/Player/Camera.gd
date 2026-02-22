extends Camera2D

var Desired_Offset : Vector2
var Min_Offset : float = -100
var Max_Offset : float = 100

func _process(delta: float) -> void:
	Desired_Offset = (get_global_mouse_position() - position ) * 0.5
	Desired_Offset.x = clamp(Desired_Offset.x, Min_Offset, Max_Offset)
	Desired_Offset.y = clamp(Desired_Offset.y, Min_Offset/2, Max_Offset/2)
	
	global_position = get_parent().get_node("Player").global_position + Desired_Offset
