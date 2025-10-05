class_name InGameState extends StateBase

## Game's state. Respawn player and register checkpoints.

signal in_game_process()
signal player_spawned()
signal reached_goal(msec: int)

## Player scene to be generated.
@export var _player_scene: PackedScene
## Marker2D to follow the player; used for camera control.
@export var _player_tracker: Marker2D
## Player's initial spawn position.
@export var _player_start: Marker2D
## When this checkpoint is activated, the game is cleared.
@export var _goal_check_point: CheckPoint
## State to be transited when the game is cleared.
@export var _next_state: StateBase

var current_time_msec: int
var attempts: int

var _mr_string: MrSpring
var _spawn_position: Vector2
var _start_time_msec: int
var _end_time_msec: int


func _ready() -> void:
	assert(_player_scene, "player_scene is null.")
	assert(_player_tracker, "player_tracker is null.")
	assert(_player_start, "player_start is null.")
	assert(_goal_check_point, "goal_check_point is null.")
	assert(_next_state, "next_state is null.")


func _process(delta: float) -> void:
	if _mr_string:
		_player_tracker.global_position = _mr_string.global_position
	
	current_time_msec += int(delta * 1000)
	
	in_game_process.emit()


func _on_registered() -> void:
	_goal_check_point.activated.connect(_on_reached_goal)
	_spawn_position = _player_start.global_position
	_register_checkpoints()


func _on_state_enter() -> void:
	_start_time_msec = Time.get_ticks_msec()
	current_time_msec = SaveSystem.load_with_key("progress_msec", 0)
	attempts = SaveSystem.load_with_key("progress_attempts", 0)
	_spawn_position = SaveSystem.string_to_vector2(SaveSystem.load_with_key("progress_checkpoint", _player_start.global_position))
	_spawn_player.call_deferred()


func _on_state_exit() -> void:
	_end_time_msec = Time.get_ticks_msec()
	_player_tracker.global_position = _goal_check_point.global_position


func pause_game(value: bool) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED if value else Node.PROCESS_MODE_INHERIT
	_mr_string.process_mode = Node.PROCESS_MODE_DISABLED if value else Node.PROCESS_MODE_INHERIT

	# 進捗を保存
	if value:
		SaveSystem.save_with_key("progress_msec", current_time_msec)
		SaveSystem.save_with_key("progress_attempts", attempts)
		SaveSystem.save_with_key("progress_checkpoint", _spawn_position)


func _register_checkpoints() -> void:
	var check_points := get_tree().get_nodes_in_group("check_point")
	for check_point in check_points:
		if check_point is CheckPoint:
			check_point.activated.connect(_on_check_point_activated)


func _spawn_player() -> void:
	attempts += 1
	_mr_string = _player_scene.instantiate()
	_mr_string.global_position = _spawn_position
	get_tree().current_scene.add_child(_mr_string)
	_mr_string.dead.connect(_spawn_player)
	player_spawned.emit()


func _on_check_point_activated(check_point: CheckPoint) -> void:
	_spawn_position = check_point.get_respawn_position()


func _on_reached_goal(_check_point: CheckPoint) -> void:
	_update_best_time()
	reached_goal.emit(current_time_msec)
	transit_state(_next_state)


func _update_best_time() -> void:
	# If the clearing time is shorter than the best time,
	# or no data is avaiable, update the best time.
	var msec: Variant = SaveSystem.load_with_key("best_msec")
	if not msec is float or current_time_msec < msec:
		SaveSystem.save_with_key("best_msec", current_time_msec)
