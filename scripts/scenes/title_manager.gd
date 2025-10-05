class_name TitleManager extends CanvasLayer

## Manage the UI of the title screen.

## File path of the game scene.
@export_file("*.tscn") var game_scene_path: String

# Buttons
@onready var _play_button: Button = $Panel/NewGameButton
@onready var _continue_button: Button = $Panel/ContinueButton
@onready var _quit_button: Button = $Panel/QuitButton
@onready var _credit_button: Button = $Panel/CreditButton
@onready var _setting_button: Button = $Panel/SettingButton
# Panels
@onready var _credit_panel: PanelWindow = $Panel/CreditPanel
@onready var _setting_panel: PanelWindow = $Panel/SettingPanel
# Others
@onready var _best_time: Label = $Panel/TimePanel/BestTime
@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	FadePanel.hide_panel()
	ResourceLoader.load_threaded_request(game_scene_path)
	
	# Setup buttons.
	_play_button.pressed.connect(_on_play_pressed)
	_continue_button.pressed.connect(_on_continue_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)
	_credit_button.pressed.connect(_credit_panel.show_panel)
	_setting_button.pressed.connect(_setting_panel.show_panel)
	
	# Setup button sounds.
	_play_button.pressed.connect(_audio_player.play)
	_continue_button.pressed.connect(_audio_player.play)
	_quit_button.pressed.connect(_audio_player.play)
	_credit_button.pressed.connect(_audio_player.play)
	_setting_button.pressed.connect(_audio_player.play)
	_credit_panel.hid.connect(_audio_player.play)
	_setting_panel.hid.connect(_audio_player.play)
	
	_show_best_time()


func _show_best_time() -> void:
	var msec: Variant = SaveSystem.load_with_key("best_msec")
	if msec is float:
		_best_time.text = Common.msec_to_str(msec)
	else:
		_best_time.text = "--:--.--"


func _on_play_pressed() -> void:
	# 保存されたデータを削除
	SaveSystem.save_with_key("progress_msec", 0)
	SaveSystem.save_with_key("progress_attempts", 0)
	SaveSystem.save_with_key("progress_checkpoint", Vector2.ZERO)

	_load_game()


func _on_continue_pressed() -> void:
	_load_game()

func _on_quit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _load_game() -> void:
	FadePanel.show_panel()
	await FadePanel.showed
	await get_tree().create_timer(0.2).timeout
	var scene: PackedScene = ResourceLoader.load_threaded_get(game_scene_path)
	get_tree().change_scene_to_packed(scene)