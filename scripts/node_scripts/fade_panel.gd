extends CanvasLayer

signal showed()
signal hid()

var _tween: Tween

@onready var _color_rect: ColorRect = $ColorRect


func show_panel(duration: float = 1.0, color: Color = Color.BLACK) -> void:
	visible = true
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(_color_rect, "color", color, duration)
	_tween.finished.connect(func() -> void:
		showed.emit()
	)


func hide_panel(duration: float = 1.0) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = get_tree().create_tween()
	var clear := _color_rect.color
	clear.a = 0
	_tween.tween_property(_color_rect, "color", clear, duration)
	_tween.finished.connect(func() -> void:
		visible = false
		hid.emit()
	)
