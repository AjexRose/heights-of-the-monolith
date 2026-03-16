extends Sprite2D

func _on_mouse_over_range_mouse_entered() -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("enabled", true)
		print("Shader enabled")
	else:
		push_warning("No ShaderMaterial found on this Sprite2D!")
	print("mouse over")

func _on_mouse_over_range_mouse_exited() -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("enabled", false)
	print("mouse not over")
