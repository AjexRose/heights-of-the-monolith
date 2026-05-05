extends Node2D

@onready var AudioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_audio_stream_player_2d_finished():
	AudioPlayer.play()
