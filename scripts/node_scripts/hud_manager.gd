class_name HUDManager extends CanvasLayer


@export var _fixed_timer_color: Color
@export_file var _title_scene_path: String

@onready var _timer_label: Label = $Frame/TimerLabel
@onready var _title_button: Button = $Frame/TitleButton
@onready var _panel_title_button: Button = $Frame/PausePanel/PanelTitleButton
@onready var _pause_button: Button = $Frame/PauseButton
@onready var _pause_panel: PanelWindow = $Frame/PausePanel
@onready var _in_game_state: InGameState = $"../GameStateMachine/InGameState"
@onready var _finished_state: FinishedState = $"../GameStateMachine/FinishedState"
@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	FadePanel.hide_panel()
	_title_button.hide()
	
	# Setup pause panel.
	_pause_button.pressed.connect(_pause_panel.show_panel)
	_pause_panel.showed.connect(_on_show_pause_panel)
	_pause_panel.hid.connect(_on_hide_pause_panel)
	_panel_title_button.pressed.connect(_on_title_pressed)
	
	# Connect game events.
	_in_game_state.in_game_process.connect(_update_timer)
	_in_game_state.reached_goal.connect(_on_reached_goal)
	_finished_state.end_slow.connect(_on_end_slow)


func _on_show_pause_panel() -> void:
	ResourceLoader.load_threaded_request(_title_scene_path)
	_pause_button.hide()
	_audio_player.play()
	_in_game_state.pause_game(true)


func _on_hide_pause_panel() -> void:
	_pause_button.show()
	_audio_player.play()
	_in_game_state.pause_game(false)


func _update_timer() -> void:
	_timer_label.text = Common.msec_to_str(_in_game_state.current_time_msec)


func _on_title_pressed() -> void:
	_audio_player.play()
	FadePanel.show_panel()
	await FadePanel.showed
	var scene := ResourceLoader.load_threaded_get(_title_scene_path)
	get_tree().change_scene_to_packed(scene)


func _fix_timer(msec: int) -> void:
	_timer_label.modulate = _fixed_timer_color
	_timer_label.text = Common.msec_to_str(msec)


func _on_reached_goal(msec: int) -> void:
	_in_game_state.in_game_process.disconnect(_update_timer)
	_pause_button.hide()
	_fix_timer(msec)


func _on_end_slow() -> void:
	_title_button.show()
	_title_button.pressed.connect(_on_title_pressed)
	ResourceLoader.load_threaded_request(_title_scene_path)

