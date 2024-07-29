class_name CheckPoint extends Area2D

## Update the player's respawn point when activated. Requires CheckPointBox and Marker2D as child nodes.

signal activated(check_point: CheckPoint)

## Enable whether this checkpoint should be activated at the start of the game. (for debugging)
@export var _activated_when_start: bool = false

var _is_activated: bool = false

@onready var _check_box: CheckPointBox = $CheckPointBox
@onready var _respawn_point: Marker2D = $Marker2D


func _enter_tree() -> void:
	add_to_group("check_point")


func _ready() -> void:
	assert(_check_box, "CheckPoint must have a CheckPointBox.")
	assert(_respawn_point, "CheckPoint must have a Marker2D.")
	
	body_entered.connect(_on_body_entered)
	
	if _activated_when_start:
		_activate_process()


func get_respawn_position() -> Vector2:
	return _respawn_point.global_position


func _on_body_entered(body: Node2D) -> void:
	if _is_activated:
		return
	
	if not body.is_in_group("player"):
		return
	
	_activate_process.call_deferred()


func _activate_process() -> void:
	monitoring = false
	monitorable = false
	_is_activated = true
	_check_box.check()
	activated.emit(self)
