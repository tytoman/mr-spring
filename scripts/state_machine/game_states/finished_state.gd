class_name FinishedState extends StateBase

## Game's state. Performs slow motion and plays sound effects when game is cleared.

signal start_slow()
signal end_slow()

@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_state_enter() -> void:
	start_slow.emit()
	_audio_player.play()
	Engine.time_scale = 0.3
	await get_tree().create_timer(1.0).timeout
	Engine.time_scale = 1.0
	end_slow.emit()
