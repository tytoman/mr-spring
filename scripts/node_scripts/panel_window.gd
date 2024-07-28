class_name PanelWindow extends Panel


signal showed()
signal hid()

@export var _anim_duration: float = 0.3
@export var _hide_direction: Vector2 = Vector2.DOWN

var _initial_position: Vector2
var _hide_position: Vector2

@onready var _close_button: Button = $CloseButton


func _ready() -> void:
	_initial_position = position
	_hide_position = _initial_position + _hide_direction * Vector2(get_window().size)
	position = _hide_position
	_close_button.pressed.connect(hide_panel)


func show_panel() -> void:
	visible = true
	showed.emit()
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "position", _initial_position, _anim_duration)


func hide_panel() -> void:
	var tween := get_tree().create_tween()
	hid.emit()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "position", _hide_position, _anim_duration)
	await tween.finished
	visible = false
