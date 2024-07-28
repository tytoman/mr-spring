class_name CheckPointBox extends AnimatedSprite2D

@onready var _audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func check() -> void:
	_audio_player.play()
	play("check")
