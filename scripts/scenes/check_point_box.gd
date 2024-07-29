class_name CheckPointBox extends AnimatedSprite2D

## Required appearance for CheckBox. Also plays sound effects.

@onready var _audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func check() -> void:
	_audio_player.play()
	play("check")
