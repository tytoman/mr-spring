extends Control

## Slider to adjust the sound volume.

@onready var _slider: HSlider = $Slider
@onready var _master_bus := AudioServer.get_bus_index("Master")


func _ready() -> void:
	_slider.value_changed.connect(_on_sound_volume_slider_changed)
	_slider.value = db_to_linear(AudioServer.get_bus_volume_db(_master_bus))


func _on_sound_volume_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_master_bus, linear_to_db(value))
	AudioServer.set_bus_mute(_master_bus, is_zero_approx(value))
