extends Control

@onready var MainMenuAudioPlayer : AudioStreamPlayer2D = $MainMenuAudioPlayer

@onready var player : Player

func _ready():
	if GameManager.player:
		GameManager.player.queue_free()
		GameManager.player = null
	
	if GameManager.camera:
		GameManager.camera.queue_free()
		GameManager.camera = null

func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://Levels/rega_house.tscn")

func _on_settings_btn_pressed() -> void:
	pass # Replace with function body.

func _on_quit_bun_pressed() -> void:
	get_tree().quit()

func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/credits_menu.tscn")

func _on_main_menu_audio_player_finished():
	MainMenuAudioPlayer.play()
