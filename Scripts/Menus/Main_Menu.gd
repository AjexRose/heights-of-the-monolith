extends Control

func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://Levels/sandbox.tscn")

func _on_settings_btn_pressed() -> void:
	pass # Replace with function body.

func _on_quit_bun_pressed() -> void:
	get_tree().quit()
