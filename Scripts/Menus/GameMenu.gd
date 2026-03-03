extends CanvasLayer

func _ready():
	self.hide()

func _on_resume_btn_pressed():
	GlobalSignals.GameMenu_Resumed.emit()
	print("unpausing")

func _on_settings_btn_pressed():
	pass

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
